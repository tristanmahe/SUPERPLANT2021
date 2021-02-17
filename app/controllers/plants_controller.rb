class PlantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]

  def index
    @plants = policy_scope(Plant).order(created_at: :desc)
  end

  def show
    @plant = Plant.find(params[:id])
    @rental = Rental.new
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

    if @plant.save!
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

  def compute_plant_status(plant)
    return "Available" if plant.rentals == []
    current_date = (DateTime.now.to_date - Date.new(2001)).to_i
    tracker = true
    plant.rentals.each do |rental|
      start_date = (rental.start_date.to_date - Date.new(2001)).to_i
      end_date = (rental.end_date.to_date - Date.new(2001)).to_i
      tracker = false unless current_date > end_date || current_date < start_date
    end
    return "Available" if tracker == true
    return "Currently unavailable"
  end

  def plant_status(plant)
    plant.status = compute_plant_status(plant)
  end

  def plantarray_status(plantarray)
    plantarray.each {|plant| plant.status = compute_plant_status(plant)}
  end

end
