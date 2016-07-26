class PluginsController < ApplicationController
  before_action :set_server

  def index
    @plugins = Plugin.all
  end

  def create
    @plugin = Plugin.find {|p| p.slug == params[:slug] }.first
    redirect_to server_plugin_path(server_id: @server.id), notice: "Plugin not found" if @plugin.nil?

    @server.dokku_cmd("plugin:install", [@plugin.install_cmd])
    @server.plugins << @plugin.slug
    @server.save
    redirect_to server_plugins_path(server_id: @server.id),notice: "Plugin was installed"
  end

  def set_server
    @server = Server.find(params[:server_id])
  end
end
