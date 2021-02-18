class PlantsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show index]

  def index
    @plants = policy_scope(Plant).order(created_at: :desc)
    plantarray_status(@plants)

    @markers = @plants.map do |plant|
      next if plant.user.latitude.nil?
      {
        lat: plant.user.latitude,
        lng: plant.user.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { plant: plant }),
        image_url: helpers.asset_url('https://res.cloudinary.com/dokxdrjbd/image/upload/v1613657324/pefeasa1eawrmiyvdhh5.png')
      }
    end
  end

  def show
    @plant = Plant.find(params[:id])
    plant_status(@plant)
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
    plant_status(@plant)
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
      :species, :status, :pricing, :photo
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
    plantarray.each { |plant| plant.status = compute_plant_status(plant) }
  end
end
