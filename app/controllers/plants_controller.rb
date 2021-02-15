class PlantsController < ApplicationController

  def index
    @plants = Plant.all
  end

  def show
    @plant = Plant.find(params[:id])
  end

  def new
    @plant  = Plant.new
  end

  def create
    @plant = Plant.new(plant_params)
    @plant.user = current_user
    @plant.save!
    if @plant.save
      flash[:success] = "Plant successfully created"
      redirect_to plant_path(@plant)
    else
      flash[:error] = "something wrong"
      render :new
    end
  end

  def edit
    @plant = Plant.find(params[:id])
  end

  def update
    @plant = Plant.find(params[:id])
    @plant.update(plant_params)
    redirect_to plant_path(@plant)
  end

  # def destroy
  #   @plant = Plant.find(params[:id])
  #   @plant.destroy
  #   redirect_to plants_path
  # end

  private

  def plant_params
    params.require(:plant).permit(
      :species, :Status, :Pricing
    )
  end
end
