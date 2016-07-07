class PluginsController < ApplicationController
  before_action :set_host

  def index
    @plugins = Plugin.all
  end

  def create
    @plugin = Plugin.find {|p| p.slug == params[:slug] }.first
    redirect_to host_plugin_path(host_id: @host.id), notice: "Plugin not found" if @plugin.nil?

    @host.dokku_cmd("plugin:install", [@plugin.install_cmd])
    @host.plugins << @plugin.slug
    @host.save
    redirect_to host_plugins_path(host_id: @host.id),notice: "Plugin was installed"
  end

  def set_host
    @host = Host.find(params[:host_id])
  end
end
