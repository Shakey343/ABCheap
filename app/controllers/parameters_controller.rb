class ParametersController < ApplicationController
  before_action :set_params, only: [:create]

  def show
    parameter = Parameter.find(params[:id])
    data = FakeData.where("origin ILIKE '%#{parameter.origin}%'").where("destination ILIKE '%#{parameter.destination}%'").where("start_time >= '#{parameter.earliest_start}'").where("end_time <= '#{parameter.latest_finish}'")
    fastest = data.min_by(&:duration)
    cheapest = data.min_by(&:cost)
  end

  def recommended(data)
    total_cost = {}
    data.each do |trip|
      deviation = (trip.start_time.to_time - parameter.to_time) / 3600
      total_cost[trip.id] = (trip.cost + ((trip.duration / 60) * 7) + (deviation.abs * 2))
    end
    total_cost.min_by { |_, v| v }
  end

  def new
    @paramter = Parameter.new
  end

  def create
    @parameter = Parameter.new(set_params)
    @parameter.user = current_user

    if @parameter.save
      direct_to "#"
    else
      render :new
    end
  end

  private

  def set_params
    params.require(:paramter).permit(:origin, :destination, :preferred_start, :earliest_start, :latest_finish)
  end
end
