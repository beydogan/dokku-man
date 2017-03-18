class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy, :sync]

  # GET /servers
  # GET /servers.json
  def index
    @servers = current_user.servers
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
    @plugins = Plugin.all
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers
  # POST /servers.json
  def create
    @server = current_user.servers.new(server_params)

    respond_to do |format|
      if @server.save
        format.html { redirect_to @server, notice: 'Server was successfully created.' }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1
  # PATCH/PUT /servers/1.json
  def update
    respond_to do |format|
      if @server.update(server_params)
        format.html { redirect_to @server, notice: 'Server was successfully updated.' }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    @server.destroy
    respond_to do |format|
      format.html { redirect_to servers_url, notice: 'Server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sync
    ServerCommandRunnerJob.perform_later(@server.id, "sync!")
    render json: {status: :ok}
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
