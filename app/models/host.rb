require 'net/ssh'

class Host < ApplicationRecord


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

  def dokku_cmd(cmd)
    execute("dokku #{cmd}")
  end

  def create_app(app_name)
    dokku_cmd "apps:create #{app_name}"
  end
end
