class DashboardsController < ApplicationController
  def show
    @rentals = Rental.where(user_id: current_user)
    rentalarray_status(@rentals)
    @my_rentals = Rental.includes(:plant).where(plants: {user_id: current_user.id})
    rentalarray_status(@my_rentals)
    @my_plants = current_user.plants
    plantarray_status(@my_plants)
    authorize @rentals
  end

  private

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

  def compute_rental_status(rental)
    start_date = (rental.start_date.to_date - Date.new(2001)).to_i
    end_date = (rental.end_date.to_date - Date.new(2001)).to_i
    current_date = (DateTime.now.to_date - Date.new(2001)).to_i
    if current_date < start_date
      return "Booking"
    elsif current_date > end_date
      return "Completed"
    else
      return "Active"
    end
  end

  def rental_status(rental)
    rental.status = compute_rental_status(rental)
  end

  def rentalarray_status(rentalarray)
    rentalarray.each { |rental| rental.status = compute_rental_status(rental) }
  end
end
