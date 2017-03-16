class ServerCommandRunnerJob < ApplicationJob
  queue_as :default

  def perform(server_id, action, *params)
    server = Server.find(server_id)
    begin
      
    rescue Exception => e
      puts e
    end
  end
end
