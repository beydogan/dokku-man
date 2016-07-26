class SshKey < ApplicationRecord
  belongs_to :server

  before_create :add_to_server

  def add_to_server
    result = self.server.execute("echo '#{self.key}' | sshcommand acl-add dokku #{self.name}")
    self.fingerprint = result.gsub("\n", "")
  end
end
