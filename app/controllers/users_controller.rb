class UsersController < ApplicationController
  def show
    @user = current_user
    @user_bookings = Booking.where(user_id: current_user)
    @favourites = FakeData.where(user_id: current_user)
    @recents = FakeData.where(user_id: current_user)
    @upcoming = FakeData.where(user_id: current_user)
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
