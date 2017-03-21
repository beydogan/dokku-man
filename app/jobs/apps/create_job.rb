class Apps::CreateJob < ApplicationJob
  queue_as :default

  def perform(app_id)
    @app = App.find(app_id)
    @server = @app.server
    cmd = @server.server_commands.create!(command: "apps:create #{@app.name}", sync: true)
    if cmd.run
      @app.created!
      notify_socket!(:app_creation_success)
    else
      notify_socket!(:app_creation_failed)
    end
  end

  def notify_socket!(action)
    Notifier.call(
        server: @server,
        action: action,
        i18n_vars: {name: @app.name},
        reload_page: true,
        reload_element_check: ".app-details"
    )
  end
end
