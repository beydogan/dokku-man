
class Server < ApplicationRecord
  include SSHKeyGenerator
  include DokkuAPI
  has_many :apps
  has_many :plugin_instances
  has_many :ssh_keys
  has_many :server_commands
  has_many :server_logs
  belongs_to :user

  def run(command, sync = true)
    sc = self.server_commands.create(command: command, sync: sync)
    sc.run
    sc.dokku_output
  end

  def non_core_plugins
    self.plugins.select {|p| p["type"] != "core" }.flatten
  end

  def to_s
    self.name
  end
end
