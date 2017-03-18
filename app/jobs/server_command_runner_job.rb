class ServerCommandRunnerJob < ApplicationJob
  queue_as :default

  def perform(server_id, action, *params)
    begin

    rescue Exception => e
      puts e
    end
  end
end
