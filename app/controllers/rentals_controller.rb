class RentalsController < ApplicationController
  before_action :set_plant, only: [:create]

  def index
    @rentals = Rental.all
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.plant = @plant
    @rental.user = current_user
    authorize @rental

    if @rental.save!
      flash[:success] = "Rental successfully created"
      redirect_to plants_path
    else
      flash[:error] = "something wrong"
      render :new
    end
  end

  private

  def rental_params
    params.require(:rental).permit(
      :status, :cost, :start_date, :end_date
    )
  end

  def set_plant
    @plant = Plant.find(params[:plant_id])
  end
end
