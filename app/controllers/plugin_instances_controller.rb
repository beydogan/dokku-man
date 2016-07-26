class PluginInstancesController < ApplicationController
  before_action :set_server

  def new
    @plugin_instance = PluginInstance.new
    load_form_data
  end

  def create
    @plugin_instance = @server.plugin_instances.new(plugin_instance_params)

    if @plugin_instance.save
      redirect_to @plugin_instance.app || @server, notice: 'Instance was successfully created.'
    else
      @plugin_instance = @plugin_instance.becomes(PluginInstance)
      load_form_data
      render :new
    end
  end

  private

  def plugin_instance_params
    params.require(:plugin_instance).permit(:name, :type, :app_id)
  end

  def set_server
    @server = Server.find(params[:server_id])
  end

  def load_form_data
    @plugins = Plugin.all #TODO filter server plugins
    @apps = @server.apps
  end
end
