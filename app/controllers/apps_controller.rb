class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy, :sync]

  def sync
    method = (params[:sync_method] == "push") ? App::PUSH : App::PULL

    begin
      @app.sync(method)
      redirect_to @app, notice: "App was successfully synced."
    rescue
      redirect_to @app, notice: "An error occured. See logs."
    end
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
    @app = App.new(app_params)

    respond_to do |format|
      if @app.save
        format.html { redirect_to @app, notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app.destroy
    respond_to do |format|
      format.html { redirect_to apps_url, notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    def load_form_data
      @servers = current_user.servers
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:name, :url, :server_id,
                                  app_configs_attributes: [:id, :name, :value, :_destroy]
      )
    end
end
