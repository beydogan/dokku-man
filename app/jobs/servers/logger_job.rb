class Servers::LoggerJob < ApplicationJob
  queue_as :default

  def perform(server_id, tag, message, timestamp, status = :info, executor = nil)
    @server = Server.find(server_id)

    details = "[%s] %s" % [tag, message]
    @server.server_logs.create!(details: details, status: status, user: executor, timestamp: timestamp)
  end

end
