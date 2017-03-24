class Servers::SyncJob < ApplicationJob
  queue_as :default

  def perform(server_id)
    @server = Server.find(server_id)

    notify_socket!(:server_sync_started)
    @server.transaction do
      sync_apps!
      sync_plugins!
      sync_plugin_instances!
    end
    notify_socket!(:server_sync_completed, true)
  end

  def sync_apps!
    result = @server.run("apps")
    apps = result.collect {|i| i[:name]}

    apps.each do |app_name|
      app = @server.apps.find_by(name: app_name) || @server.apps.create(name: app_name, status: App.statuses[:created])
      Apps::SyncJob.new.perform(app.id)
    end

    # Check apps that are on dokku-man but not exist on server
    @server.apps.where("name NOT IN (?)", apps).update_all(status: App.statuses["not_exist"])
  end

  def sync_plugins!
    result = @server.run("plugin")
    @server.update! plugins: result
  end

  def sync_plugin_instances!
    @server.plugin_instances.destroy_all

    @server.non_core_plugins.collect {|p| p["name"] }.each do |plugin_name|
      plugin = Plugin.find(plugin_name) rescue nil
      next if plugin.nil?

      # Get list of plugin instances. E.g.: postgres:list
      list = @server.run(plugin.list_cmd)
      list.each do |item|

        # Get the app
        app = App.find_by(name: item[:links]) unless item[:links] == "-"

        # Create the instance and link to app if app exists
        instance = @server.plugin_instances.
            find_or_create_by!(
                name: item[:name],
                app: app,
                type: plugin.class_name
            )

        instance.app.present? ? instance.linked! : instance.created!
      end
    end
  end

  def notify_socket!(action, reload_page = false)
    Notifier.call(
        server: @server,
        action: action,
        i18n_vars: {server: @server.name},
        reload_page: true
    )
  end
end
