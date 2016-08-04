# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class AppLoggerChannel < ApplicationCable::Channel
  def subscribed
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def subscribed_to_app(params)
    stream_from "app_logger:app_#{params["app_id"]}"
  end
end
