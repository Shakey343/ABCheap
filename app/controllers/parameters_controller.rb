class ParametersController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  before_action :set_params, only: [:create]

  def show
    @booking = Booking.new
    @parameter = Parameter.find(params[:id])
    data = FakeData.where(
      "origin ILIKE '%#{@parameter.origin}%'"
    ).where(
      "destination ILIKE '%#{@parameter.destination}%'"
    ).where(
      "start_time >= '#{@parameter.earliest_start}'"
    ).where(
      "end_time <= '#{@parameter.latest_finish}'"
    )
    @fastest = data.min_by(&:duration)
    @cheapest = data.min_by(&:cost)

    @recommended = FakeData.find(recommended(data, @parameter.preferred_start).first)

    @markers = []

    origin = {lat: Geocoder.search(@parameter.origin).first.data["lat"], lng: Geocoder.search(@parameter.origin).first.data["lon"] }
    @markers << origin

    destination = {lat: Geocoder.search(@parameter.destination).first.data["lat"], lng: Geocoder.search(@parameter.destination).first.data["lon"] }
    @markers << destination

    @markers.each do |marker|
      {
        lat: marker[:lat],
        lng: marker[:lng]
      }
    end
  end

  def recommended(data, preferred_start)
    total_cost = {}
    data.each do |trip|
      deviation = ((trip.start_time.to_time - preferred_start.to_time) / 3600).abs
      total_cost[trip.id] = (trip.cost + ((trip.duration / 60) * 7) + (deviation * 2))
    end
    total_cost.min_by { |_, v| v }
  end

  def new
    @parameter = Parameter.new
  end

  def create
    @parameter = Parameter.new(set_params)
    @parameter.user = current_user
    if @parameter.save
      redirect_to parameter_path(@parameter)
    else
      render :new
    end
  end

  private

  def set_params
    params.require(:parameter).permit(:origin, :destination, :preferred_start, :earliest_start, :latest_finish)
  end
end
