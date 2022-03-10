class ParametersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create, :show]
  before_action :set_params, only: [:create]

  def show
    FakeData.where('booked != true').destroy_all
    Parameter.where('id != ?', params[:id]).destroy_all
    # FakeData.destroy_all
    @booking = Booking.new
    @parameter = Parameter.find(params[:id])

    origin_strip = @parameter.origin.strip
    if @parameter.origin.count("0-9") != 0
      origin_strip = @parameter.origin.gsub(/\s+/, "").insert(-4, " ")
    end

    destination_strip = @parameter.destination.strip
    if @parameter.destination.count("0-9") != 0
      destination_strip = @parameter.destination.gsub(/\s+/, "").insert(-4, " ")
    end

    @parameter.update(origin: Geocoder.search(origin_strip).first.data["address"]["city"])
    @parameter.update(destination: Geocoder.search(destination_strip).first.data["address"]["city"])
    FakeData.generate_results(@parameter)

    if @parameter.car
      lat_diff = (Geocoder.search(@parameter.origin).first.data["lat"].to_f - Geocoder.search(@parameter.destination).first.data["lat"].to_f).abs
      lon_diff = (Geocoder.search(@parameter.origin).first.data["lon"].to_f - Geocoder.search(@parameter.destination).first.data["lon"].to_f).abs

      if @parameter.passengers.to_i.zero?
        passengers = 1
      else
        passengers = @parameter.passengers.to_f
      end

      distance = (Math.sqrt((lat_diff * lat_diff) + (lon_diff * lon_diff)) * 73).to_f
      time = ((distance / 54) * 60).to_i
      price_per_mile = 0.2
      cost = distance * price_per_mile
      FakeData.create!(
        origin: @parameter.origin,
        destination: @parameter.destination,
        price_cents: ((cost * 100).round(2) / (passengers ** 0.9)),
        start_time: @parameter.preferred_start + 100,
        end_time: @parameter.preferred_start + (time * 60),
        duration: time,
        mode: "car"
      )
    end

    if @parameter.earliest_start.nil?
      if @parameter.preferred_start < DateTime.now
        earliest_start_date = @parameter.preferred_start
      elsif @parameter.preferred_start - 14400 < DateTime.now
        earliest_start_date = DateTime.now
      else
        earliest_start_date = @parameter.preferred_start - 14400
      end
    else
      earliest_start_date = @parameter.earliest_start
    end

    if @parameter.latest_finish.nil?
      if FakeData.where('booked != true').count != 0 && FakeData.where('booked != true').last.mode != "bus"
        latest_finish_date = @parameter.preferred_start + (120 * FakeData.last.duration) + 7200
      elsif FakeData.where('booked != true').count != 0 && FakeData.where('booked != true').last.mode == "bus"
        latest_finish_date = @parameter.preferred_start + (60 * FakeData.last.duration) + 7200
      else
        latest_finish_date = @parameter.preferred_start + 36000
      end
    else
      latest_finish_date = @parameter.latest_finish
    end

    valid_data = FakeData.where("price_cents != 0 AND booked != true AND end_time < ? AND start_time > ?", latest_finish_date, earliest_start_date)

    if @parameter.railcard
      valid_data.where("mode = 'train'").each do |result|
        result.update(price_cents: (result.price_cents * 2 / 3).round(2))
      end
    end

    if valid_data.all.count.zero?
      redirect_to '/500.html'
    else
      @fastest = valid_data.min_by(&:duration)
      @cheapest = valid_data.min_by(&:price_cents)
      if valid_data.where(price_cents: @cheapest.price_cents).length >= 1
        @cheapest = valid_data.find(recommended(valid_data.where(price_cents: @cheapest.price_cents), @parameter.preferred_start)[0].first)
      end
      if valid_data.where(duration: @fastest.duration).length >= 1
        @fastest = valid_data.find(recommended(valid_data.where(duration: @fastest.duration), @parameter.preferred_start)[0].first)
      end
      @recommended = valid_data.find(recommended(valid_data.all, @parameter.preferred_start)[0].first)
      @other_recommended = []
      if valid_data.count > 3
        @other_recommended << valid_data.find(recommended(valid_data.all, @parameter.preferred_start)[1].first)
        @other_recommended << valid_data.find(recommended(valid_data.all, @parameter.preferred_start)[2].first)
        @other_recommended << valid_data.find(recommended(valid_data.all, @parameter.preferred_start)[3].first)
      end
    end







    @markers = []

    origin = { lat: Geocoder.search(@parameter.origin).first.data["lat"], lng: Geocoder.search(@parameter.origin).first.data["lon"],
      image_url: helpers.asset_url("origin.png")
    }
    @markers << origin

    destination = { lat: Geocoder.search(@parameter.destination).first.data["lat"], lng: Geocoder.search(@parameter.destination).first.data["lon"],
      image_url: helpers.asset_url("destination.png")
    }
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
      total_cost[trip.id] = (trip.price.to_f + ((trip.duration.to_f / 60) * 7) + (deviation * 2))
    end
    total_cost.sort_by { |_, v| v }
  end

  def new
    @parameter = Parameter.new
    @markers = []
  end

  def create
    @parameter = Parameter.new(set_params)
    if @parameter.save
      redirect_to parameter_path(@parameter)
    else
      render :new
    end
  end

  private

  def set_params
    params.require(:parameter).permit(:origin, :destination, :preferred_start, :earliest_start, :latest_finish, :car, :railcard, :passengers)
  end
end
