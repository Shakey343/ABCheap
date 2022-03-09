class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :destroy]

  def create
    trip = FakeData.find(params[:booking][:fake_data_id])
    @booking = Booking.create!(user: current_user, fake_data: trip, amount: trip.price, state: "pending")
    # @booking.user = current_user
    # @booking.fake_data = trip
    # @booking.amount = trip.price
    # @booking.state = 'pending'

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        name: "#{trip.origin} to #{trip.destination} on #{trip.start_time.strftime("%-d %^b")} @ #{trip.start_time.strftime("%R")}",
        amount: trip.price_cents,
        currency: 'gbp',
        quantity: 1
      }],
      success_url: booking_url(@booking),
      cancel_url: booking_url(@booking)
    )

    trip.toggle!(:booked)
    @booking.update(checkout_session_id: session.id)
    redirect_to new_booking_payment_path(@booking)

    # if @booking.save
    #   redirect_to booking_path(@booking)
    # else
    #   redirect_to parameter_path(@parameter)
    # end
  end

  def index
    @bookings = current_user.bookings
    @upcoming_bookings = @bookings.select do |booking|
      booking.fake_data.start_time >= DateTime.now
    end
    @past_bookings = @bookings.select do |booking|
      booking.fake_data.start_time < DateTime.now
    end
  end

  def show
    @booking = current_user.bookings.find(params[:id])
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
