class WinesController < ApplicationController
  before_action :set_wine, only: [:show, :edit, :update, :destroy]

  # GET /wines
  # GET /wines.json
  def index
    @wines = Wine.all
  end

  # GET /wines/1
  # GET /wines/1.json
  def show
  end

  # GET /wines/new
  def new
    @wine = Wine.new
  end

  # GET /wines/1/edit
  def edit
  end

  # POST /wines
  # POST /wines.json
  def create
    @wine = Wine.new(name: wine_params[:name])

    respond_to do |format|
      if @wine.save
        wine_params[:strain_ids].reject(&:empty?).each_with_index do |id, index|
          WineStrain.create!(wine_id: @wine.id, strain_id: id, percentage: wine_params[:percentages][index])
        end
        format.html { redirect_to @wine, notice: 'Wine was successfully created.' }
        format.json { render :show, status: :created, location: @wine }
      else
        format.html { render :new }
        format.json { render json: @wine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wines/1
  # PATCH/PUT /wines/1.json
  def update
    respond_to do |format|
      if @wine.update(wine_params)
        format.html { redirect_to @wine, notice: 'Wine was successfully updated.' }
        format.json { render :show, status: :ok, location: @wine }
      else
        format.html { render :edit }
        format.json { render json: @wine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wines/1
  # DELETE /wines/1.json
  def destroy
    @wine.destroy
    respond_to do |format|
      format.html { redirect_to wines_url, notice: 'Wine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wine
      @wine = Wine.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def wine_params
      params.require(:wine).permit(:name, strain_ids: [], percentages: [])
    end
end
