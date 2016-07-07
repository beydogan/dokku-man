class PluginInstancesController < ApplicationController
  before_action :set_host

  def new
    @plugin_instance = PluginInstance.new
    load_form_data
  end

  def create
    @plugin_instance = @host.plugin_instances.new(plugin_instance_params)

    if @plugin_instance.save
      redirect_to @plugin_instance.app || @host, notice: 'Instance was successfully created.'
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

  def set_host
    @host = Host.find(params[:host_id])
  end

  def load_form_data
    @plugins = Plugin.all #TODO filter host plugins
    @apps = @host.apps
  end
end
