class BookingsController < ApplicationController

  before_action :set_booking, only: [:show, :destroy]

  def create
    @trip = FakeData.find(booking_params[:fake_data_id])
    @parameter = Parameter.find(params[:parameter_id])
    @booking = Booking.new
    @booking.user = current_user
    @booking.fake_data = @trip

    if @booking.save
      redirect_to booking_path(@booking)
    else
      redirect_to parameter_path(@parameter)
    end
  end

  def index
    @bookings = current_user.bookings
  end

  def show
  end

  def destroy
    @booking.destroy
  end

  private
  def booking_params
    params.require(:booking).permit(:fake_data_id)
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
