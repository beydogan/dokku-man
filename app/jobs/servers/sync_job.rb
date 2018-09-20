class Servers::SyncJob < ApplicationJob
  queue_as :default

  rescue_from Exceptions::CommandError do |e|
    Rails.logger.error("[Servers::SyncJob][CommandError] Exception: #{e.message}")
    notify_socket!(:server_sync_errored, true, 'error')
    @server.log! "SYNC", e.message, status: 'error'
    @server.error!
  end

  def perform(server_id)
    @server = Server.find(server_id)
    notify_socket!(:server_sync_started)
    @server.log! "SYNC", "Server sync has been started."

    sync_apps!
    sync_plugins!
    sync_plugin_instances!
    notify_socket!(:server_sync_completed, true)
  end

  def sync_apps!
    @server.log! "SYNC", "Starting to sync apps."

    result = @server.run("apps")
    apps = result.collect {|i| i[:name]}

    @server.log! "SYNC", "#{apps.count} apps has been found on the server."

    apps.each do |app_name|
      app = @server.apps.find_by(name: app_name) || @server.apps.create(name: app_name, status: :not_synced)
      app.just_created? ? @server.log!("SYNC", "#{app} just created.") : @server.log!("SYNC", "#{app} already exists.")
      Apps::SyncJob.perform_later(app.id)
    end

    # Check apps that are on dokku-man but not exist on server
    @server.apps.where("name NOT IN (?)", apps).update_all(status: App.statuses["not_exist"])

    @server.log! "SYNC", "App list has been updated."
  end

  def sync_plugins!
    @server.log! "SYNC", "Starting to sync installed plugin list."

    result = @server.run('plugin')
    @server.update! plugins: result

    @server.log! "SYNC", "Plugin list has been updated."

  end

  def sync_plugin_instances!
    @server.log! "SYNC", "Starting to sync services."

    @server.plugin_instances.destroy_all

    @server.non_core_plugins.collect {|p| p['name'] }.each do |plugin_name|
      plugin = Plugin.find(plugin_name) rescue nil
      next if plugin.nil?

      # Get list of plugin instances. E.g.: postgres:list
      list = @server.run(plugin.list_cmd)
      list.each do |item|

        # Get the app
        app = @server.apps.find_by(name: item[:links]) unless item[:links] == '-'

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

    @server.log! "SYNC", "Service sync has been completed."

  end

  def notify_socket!(action, reload_page = false, type = 'information')
    Notifier.call(
        server: @server,
        action: action,
        i18n_vars: {server: @server.name},
        reload_page: true,
        type: type
    )
  end
end
