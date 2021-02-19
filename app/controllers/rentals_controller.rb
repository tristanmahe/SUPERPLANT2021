class RentalsController < ApplicationController
  before_action :set_plant, only: [:create]

  def index
    @rentals = Rental.all
    rentalarray_status(@rentals)
  end

  def show
    @rental = Rental.find(params[:id])
  end

  def new
    @rental = Rental.new
  end

  def create
    @rental = Rental.new(rental_params)
    @rental.answer = 'pending'
    @rental.plant = @plant
    @rental.user = current_user
    @rental.cost = (@rental.end_date - @rental.start_date) / (60 * 60 * 24) * @plant.pricing
    authorize @rental

    if @rental.save!
      flash[:success] = "Rental successfully created"
      redirect_to dashboards_path
    else
      flash[:error] = "something wrong"
      render :new
    end
  end

  def accept
    @rental = Rental.find(params[:id])
    authorize @rental
    if @rental.update(answer: "accepted")
      redirect_to dashboards_path
    else 
      redirect_to dashboards_path, alert: "non" 
    end
  end

  def deny
    @rental = Rental.find(params[:id])
    if @rental.update(answer: "denied")
      redirect_to dashboards_path
    else 
      redirect_to dashboards_path, alert: "non" 
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

  def compute_rental_status(rental)
    start_date = (rental.start_date.to_date - Date.new(2001)).to_i
    end_date = (rental.end_date.to_date - Date.new(2001)).to_i
    current_date = (DateTime.now.to_date - Date.new(2001)).to_i
    return "Booking" if current_date < start_date
    return "Completed" if current_date > end_date

    return "Active"
  end

  def rental_status(rental)
    rental.status = compute_rental_status(rental)
  end

  def rentalarray_status(rentalarray)
    rentalarray.each { |rental| rental.status = compute_rental_status(rental) }
  end
end
