class NotifierJob < ApplicationJob
  queue_as :default

  def perform(user_id, message)
    NotificationChannel.broadcast_to "user_#{user_id}", message
  end
end
