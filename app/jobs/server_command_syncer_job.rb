## Syncs results of waiting server commands
class ServerCommandSyncer < ApplicationJob
  queue_as :default

  def perform
    begin
      ServerCommand.waiting.each do |sc|
        result = sc.server.api.run("get_command", sc.token)
      end
    rescue Exception => e
      puts e
    end
  end

  def notify_socket(data)

  end
end
