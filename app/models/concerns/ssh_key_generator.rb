module SSHKeyGenerator
  extend ActiveSupport::Concern

  included do
    attr_accessor :generate_keys
    before_save :generate_and_save_keys
  end
  
  def generate_and_save_keys
    if generate_keys == "1"
      key = SSHKey.generate
      self.private_key = key.private_key
      self.public_key = key.ssh_public_key
    end
  end
end
