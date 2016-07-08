class SshKeysController < ApplicationController
  before_action :set_host
  before_action :set_ssh_key, only: [:show, :edit, :update, :destroy]

  # GET /ssh_keys
  # GET /ssh_keys.json
  def index
    @ssh_keys = SshKey.all
  end

  # GET /ssh_keys/1
  # GET /ssh_keys/1.json
  def show
  end

  # GET /ssh_keys/new
  def new
    @ssh_key = SshKey.new
  end

  # GET /ssh_keys/1/edit
  def edit
  end

  # POST /ssh_keys
  # POST /ssh_keys.json
  def create
    @ssh_key = @host.ssh_keys.new(ssh_key_params)

    if @ssh_key.save
      redirect_to @host, notice: 'Ssh key was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ssh_keys/1
  # PATCH/PUT /ssh_keys/1.json
  def update
    if @ssh_key.update(ssh_key_params)
      redirect_to @host, notice: 'Ssh key was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ssh_keys/1
  # DELETE /ssh_keys/1.json
  def destroy
    @ssh_key.destroy
    redirect_to @host, notice: 'Ssh key was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ssh_key
      @ssh_key = SshKey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ssh_key_params
      params.require(:ssh_key).permit(:name, :key)
    end

    def set_host
      @host = Host.find(params[:host_id])
    end
end
