class SshKey < ApplicationRecord
  belongs_to :host

  before_create :add_to_host

  def add_to_host
    result = self.host.execute("echo '#{self.key}' | sshcommand acl-add dokku #{self.name}")
    self.fingerprint = result.gsub("\n", "")
  end
end
