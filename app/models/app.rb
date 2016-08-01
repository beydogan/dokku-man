class App < ApplicationRecord
  include AppCommands

  belongs_to :server
  has_many :app_configs, dependent: :destroy
  has_many :plugin_instances, dependent: :destroy

  accepts_nested_attributes_for :app_configs, reject_if: :all_blank, allow_destroy: true

  validates :name, uniqueness: {scope: :server}

  after_create :create
  after_save -> { sync(PUSH) }

  def execute(cmd, args = [])
    args = args.unshift(self.name)
    self.server.dokku_cmd("apps:#{cmd}", args)
  end

  def create
    self.execute("create")
  end

  def sync(method = PULL)
    if self.name_changed?
      self.server.dokku_cmd("apps:rename", [name_was, name])
    end
    sync_config(method)
  end

  def sync_config(method = PULL)
    if method == PUSH
      configs = app_configs.collect {|c| "#{c.name.lstrip.rstrip}='#{c.value.lstrip.rstrip}'" }.join(" ")
      self.server.dokku_cmd("config:set #{self.name} #{configs}")
    else
      self.app_configs.destroy_all
      output = self.server.dokku_cmd("config #{self.name}")
      config_strs = output.split("\n").drop(1)
      puts config_strs
      config_strs.each do |s|
        puts s
        scan = s.scan(/(([a-zA-Z\_\d])+)\:\s*(.*)\z/)[0]
        key = scan.first
        value = scan.last
        self.app_configs.create(name: key, value: value)
      end
    end
  end

  def sync_scale
    self.scale = get_scale_cmd
    self.save
  end

  def deploy(branch)
    @sh = Session::Bash.new
    o = execute_local_sh 'pwd'
    tmp = o.rstrip + "/tmp"
    execute_local_sh "cd '#{tmp}'"
    dir = "changeme"
    execute_local_sh "git clone #{git_url} #{dir}"
    execute_local_sh "cd '#{dir}'"
    execute_local_sh "git checkout '#{branch}'"
    execute_local_sh "git remote add deploy dokku@#{server.addr}:#{name}"
    execute_local_sh "git push deploy #{branch}:master"
    execute_local_sh "rm -rf ./#{dir}"
  end

  def execute_local_sh(cmd)
    output = ""
    @sh.execute cmd do |o, e|
      puts o if o
      output = output + o if o
    end
    return output
  end

  def deploy_key
    self.host.public_key
  end
end
