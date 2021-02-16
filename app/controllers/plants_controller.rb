class PlantsController < ApplicationController
  def index
    @plants = policy_scope(Plant).order(created_at: :desc)
  end

  def show
    @plant = Plant.find(params[:id])
    authorize @plant
  end

  def new
    @plant = Plant.new
    authorize @plant
  end

  def create
    @plant = Plant.new(plant_params)
    @plant.user = current_user
    authorize @plant

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
    authorize @plant
  end

  def update
    @plant = Plant.find(params[:id])
    @plant.update(plant_params)
    redirect_to plant_path(@plant)
    authorize @plant
  end

  private

  def plant_params
    params.require(:plant).permit(
      :species, :status, :pricing
    )
  end
end
