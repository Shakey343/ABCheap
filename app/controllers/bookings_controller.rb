class BookingsController < ApplicationController
  def create
    @booking = Booking.new(params[:booking])
    @booking.save
  end

  def show
    @booking = Booking.find(params[:id])
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
