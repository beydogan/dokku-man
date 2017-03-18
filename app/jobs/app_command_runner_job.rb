class AppCommandRunnerJob < ApplicationJob
  queue_as :default

  def perform(app_id, action, reload_page = false, *params)
    app = App.find(app_id)
    begin
      app.send action, *params
      app.notify_user({status: "success", message: "Finished", action: action, params: params, reload_page: reload_page})
    rescue Exception => e
      app.notify_user({status: "error", message: e.message, action: action, params: params, reload_page: reload_page})
    end
  end
end
