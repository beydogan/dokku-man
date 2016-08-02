class AppCommandRunnerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    app = App.find(args[:app_id])
    puts app
    # Do something later
  end
end
