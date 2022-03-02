class ParametersController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  def new
    @parameter = Parameter.new

    # @markers = @parameters.geocode.map do |parameter|
    #   {
    #     lat: parameter.latitude,
    #     lng: parameter.longitude
    #   }
    # end
  end
end
