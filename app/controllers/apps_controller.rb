class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy, :sync, :run_cmd, :deploy]
  before_action :set_server

  def sync
    method = (params[:sync_method] == "push") ? App::PUSH : App::PULL

    AppCommandRunnerJob.perform_later(@app.id, "sync", true, method)
    redirect_to [@server, @app], notice: "App sync was started, you will be notified once its completed."
  end

  def run_cmd
    available_commands = ["pull_branches"]

    if available_commands.include? params[:cmd]
      AppCommandRunnerJob.perform_later(@app.id, params[:cmd], true)
      redirect_to [@server, @app], notice: "Command was run successfully, you will be notified once its completed."
    else
      redirect_to [@server, @app], flash: {error: "Command not available"}
    end
  end


  def deploy
    branch = params[:_app][:branch] || "master"
    AppCommandRunnerJob.perform_later(@app.id, "deploy", true, branch)
    redirect_to [@server, @app], notice: "Deployment started, you can watch logs"
  end


  # GET /apps
  # GET /apps.json
  def index
    @apps = current_user.apps
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
  end

  # GET /apps/new
  def new
    @app = App.new
    @app.app_configs.new
    load_form_data
  end

  # GET /apps/1/edit
  def edit
    @app.app_configs.new
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = @server.apps.new(app_params)

    if @app.save
      redirect_to [@server, @app], notice: 'App was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
    if @app.update(app_params)
      redirect_to [@server, @app], notice: 'App was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app.destroy
    respond_to do |format|
      format.html { redirect_to server_apps_path(@server), notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_server
      @server = current_user.servers.find(params[:server_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
      gon.app_id = @app.id
    end

    def load_form_data
      @servers = current_user.servers
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:name, :url, :git_url, app_configs_attributes: [:id, :name, :value, :_destroy]
      )
    end
end
