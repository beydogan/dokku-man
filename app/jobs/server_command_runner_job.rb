class ServerCommandRunnerJob < ApplicationJob
  queue_as :default

  def perform(id)
    @sc = ServerCommand.find(id)
    begin

    rescue Exception => e
      puts e
    end
  end

  def enqueue_next_command!
    if @sc.next_command.present?
      @sc.next_command.enqueue!
    end
  end
end
