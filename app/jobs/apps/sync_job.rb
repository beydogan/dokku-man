class Apps::SyncJob < ApplicationJob
  queue_as :default

  def perform(app_id)
    app = App.find(app_id) rescue return

    app.syncing!

  end
end
