require 'net/ssh'

class Host < ApplicationRecord
  has_many :apps

  attr_accessor :generate_keys

  before_save :generate_and_save_keys
  before_save :parse_private_key

  def execute(cmd)
    Net::SSH.start(
        self.addr, 'root',
        auth_methods: ["publickey"],
        keys: [],
        key_data: [self.private_key]
    ) do |ssh|
      ssh.exec!(cmd)
    end
  end

  def dokku_cmd(cmd, args = [])
    args = args.join(" ")
    execute("dokku #{cmd} #{args}")
  end

  def create_app(app_name)
    dokku_cmd "apps:create #{app_name}"
  end

  def sync_apps
    app_list = dokku_cmd("apps").gsub("=====> My Apps\n", "").split("\n")

    app_list.each do |app|
      _app = self.apps.find_by name: app

      if _app.present?
        _app.sync
      else
        self.apps.create(name: app)
      end
    end
  end

  def to_s
    self.name
  end

  def generate_and_save_keys
    if generate_keys == "1"
      key = SSHKey.generate
      self.private_key = key.private_key
      self.public_key = key.ssh_public_key
    end
  end

  def parse_private_key
    self.private_key = self.private_key.gsub("\r\n          ", "\n") #TODO find better way
  end
end
