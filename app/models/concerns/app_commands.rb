module AppCommands
  extend ActiveSupport::Concern

  def get_scale_cmd
    scale = {}
    result = self.server.dokku_cmd("ps:scale #{self.name}")
    result = result.gsub("-----> ", "").gsub(" ", "").split("\n")
    list_starts_at = result.find_index("-----------") + 1
    processes = result.slice(list_starts_at..-1)
    processes.each do |p|
      name = p[/\D+/]
      size = p[/\d+/]

      scale[name] = size
    end
    scale
  end

  def set_scale_cmd(scale)
    scale_str = scale.collect {|k,v| "#{k}=#{v}"}.join(" ")
    result = self.server.dokku_cmd("ps:scale #{self.name} #{scale_str}")
  end

  def execute(cmd, args = [])
    args = args.unshift(self.name)
    self.server.dokku_cmd("apps:#{cmd}", args)
  end

  def create
    self.execute("create")
  end

  def sync(method = App::PULL)
    if self.name_changed?
      self.server.dokku_cmd("apps:rename", [name_was, name])
    end
    sync_config(method)
  end

  def sync_config(method = App::PULL)
    if method == App::PUSH
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
    tmp = "/tmp"
    execute_local_sh "cd '#{tmp}'"
    dir = "changeme"
    execute_local_sh "rm -rf ./#{dir}"
    execute_local_sh "echo #{private_key} > ./key"
    execute_local_sh "GIT_SSH_COMMAND='ssh -i ./key' git clone -b #{branch} #{git_url} #{dir}", true
    execute_local_sh "cd '#{dir}'"
    execute_local_sh "git remote add deploy dokku@#{server.addr}:#{name}"
    execute_local_sh "git push deploy #{branch}:master", true
    execute_local_sh "rm -rf ./#{dir}"
    @sh.close
  end

  def execute_local_sh(cmd, socket_log = false)
    output = ""
    @sh.execute cmd do |o, e|
      AppLoggerChannel.broadcast_to "app_#{id}", {action: "log", message: o} if o# && socket_log
      AppLoggerChannel.broadcast_to "app_#{id}", {action: "log", message: e} if e# && socket_log
      output = output + o if o
      puts o
      puts e
    end
    return output
  end

  def pull_branches
    @sh = Session::Bash.new
    o = execute_local_sh 'pwd'
    tmp = "/tmp"
    execute_local_sh "cd '#{tmp}'"
    dir = "changeme"
    execute_local_sh "rm -rf ./#{dir}"
    execute_local_sh "git clone #{git_url} #{dir}"
    execute_local_sh "cd ./#{dir}"
    execute_local_sh "git fetch --all"
    branch_output = execute_local_sh "git branch -r"
    branches = branch_output.split("\n").delete_if { |x| !x.include?("origin") || x.include?("HEAD") }.map(&:strip).map {|x| x.gsub("origin/", "")}
    self.update branches: branches
    @sh.close
  end
end
