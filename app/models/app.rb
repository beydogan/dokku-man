class App < ApplicationRecord
  include AppCommands
  include SSHKeyGenerator

  belongs_to :server
  has_one :user, through: :server

  has_many :app_configs, dependent: :destroy
  has_many :plugin_instances, dependent: :destroy

  accepts_nested_attributes_for :app_configs, reject_if: :all_blank, allow_destroy: true

  validates :name, uniqueness: {scope: :server}

  def deploy_key
    self.host.public_key
  end

  def notify_user(message)
    NotificationChannel.broadcast_to "user_#{user.id}", message
  end
end
