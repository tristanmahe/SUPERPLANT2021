class DashboardsController < ApplicationController
  def show
    @rentals = Rental.where(user_id: current_user)
    authorize @rentals
  end
end
