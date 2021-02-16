class RentalsController < ApplicationController
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
    @rental.user = current_user
    @rental.save!
    if @rental.save
      flash[:success] = "Rental successfully created"
      redirect_to rental_path(@rental)
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
end
