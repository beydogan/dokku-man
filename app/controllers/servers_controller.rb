class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy, :sync, :logs]


  ##== Member Actions
  def sync
    Servers::SyncJob.perform_later(@server.id)
    Notifier.call(
        server: @server,
        action: 'server_sync_enqueued',
        i18n_vars: {server: @server.name},
        reload_page: false,
    )
    render json: {status: :ok}
  end

  def logs
    @server_logs = @server.server_logs
  end

  ##== Crud Actions

  def index
    @servers = current_user.servers
  end

  def show
    @plugins = Plugin.all
  end

  def new
    @server = Server.new
  end

  def edit
  end

  def create
    @server = current_user.servers.new(server_params)

    if @server.save
      Servers::SyncJob.perform_later(@server.id)
      redirect_to @server, notice: 'Server was successfully created.'
    else
      render :new
    end
  end

  def update
    if @server.update(server_params)
      redirect_to @server, notice: 'Server was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @server.destroy
    redirect_to servers_url, notice: 'Server was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = current_user.servers.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def server_params
      params.require(:server).permit(:name, :addr, :endpoint, :api_key, :api_secret)
    end
end
