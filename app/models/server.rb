class Server < ApplicationRecord
  include SSHKeyGenerator
  include DokkuAPI
  enum status: [:syncing, :out_of_sync, :ok, :error]
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

  # TODO: Need another config to identify service plugins
  def service_plugins
    self.plugins.select {|p| p["type"] != "core" }.flatten
  end
  alias non_core_plugins service_plugins

  def to_s
    self.name
  end

  def has_plugin?(plugin)
    self.plugins.find{|p| p['name'] == plugin}.present?
  end

  def log!(tag, message, options = {status: 'info'})
    Servers::LoggerJob.perform_later(self.id, tag, message, DateTime.now.to_s, options[:status], self.user)
  end
end
