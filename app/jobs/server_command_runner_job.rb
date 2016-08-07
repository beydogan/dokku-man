class ServerCommandRunnerJob < ApplicationJob
  queue_as :default

  def perform(server_id, action, *params)
    server = Server.find(server_id)
    begin
      server.send action, *params
    rescue Exception => e
      puts e
    end
  end
end
