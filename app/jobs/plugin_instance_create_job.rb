class PluginInstanceCreateJob < ApplicationJob
  include ActionView::RecordIdentifier
  include RenderAnywhere
  queue_as :default

  #== Params
  #   id -> Plugin Instance ID
  #== Description
  #   Creates PluginInstance on db
  #   Creates plugin container on dokku
  #   Links created container to the app if app present
  #   Notifies the socket
  #== TODO
  #
  def perform(id)
    @pi = PluginInstance.find(id)
    @app = @pi.app
    @server = @pi.server

    begin
      create_instance!
      link_to_app! if @app.present?
      notify_socket!
    rescue Exception => e
      logger.warn("[PluginInstanceCreateJob] #{e.message}")
      logger.warn(e)
      logger.warn(e.backtrace)
    end
  end

  private

  def create_instance!
    create_result = @server.api.run("create_command", @pi.create_command, true)
    raise "UnexpectedError" if create_result["status"] == "error" || create_result["result_data"]["ok"] == false
    @pi.created!
    notify_socket!(:plugin_instance_created)
  end

  def link_to_app!
    link_result = @server.api.run("create_command", @pi.link_command(@app.name), true)
    raise "UnexpectedError" if link_result["status"] == "error" || link_result["result_data"]["ok"] == false
    @pi.linked!
    notify_socket!(:plugin_instance_linked)
  end

  def notify_socket!(action)
    Notifier.call(
        server: @server,
        action: action,
        i18n_vars: {name: @pi.name, type: @pi.type, app: @app.try(:name)},
        content_replace: true,
        content_replace_target: "##{dom_id(@pi)}",
        content_replace_payload: render_payload
    )
  end

  def render_payload
    render(
        partial: 'plugin_instances/plugin_instance_table_row',
        locals: { instance: @pi, server: @server, app: @app, server_scope: !@app.present? }
    )
  end
end
