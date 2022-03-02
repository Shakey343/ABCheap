class ParametersController < ApplicationController
  skip_before_action :authenticate_user!, only: :new
  def new
    @parameter = Parameter.new
  end
end
