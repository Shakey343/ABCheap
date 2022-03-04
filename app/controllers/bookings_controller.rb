class BookingsController < ApplicationController
  def index
    @bookings = Booking.where(user_id: current_user)
  end

  def create
    @booking = Booking.new(params[:booking])
    @booking.save
  end

  def show
    @booking = Booking.find(params[:user_id])
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
  end

  # private

  # def booking_params
  #   params.require(:booking).permit("")
  # end
end
