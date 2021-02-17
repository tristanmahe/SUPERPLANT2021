class DashboardsController < ApplicationController
  def show
    @rentals = Rental.where(user_id: current_user)
    @my_rentals = Rental.includes(:plant).where(plants: {user_id: current_user.id})
    @my_plants = current_user.plants
    authorize @rentals
  end
end
