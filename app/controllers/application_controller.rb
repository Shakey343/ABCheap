class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    @booking = Booking.last
    stored_location_for(resource) || booking_path(@booking)
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
