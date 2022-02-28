class OptionsController < ApplicationController
  before_action :set_option, only: [:show]
  before_action :start_time, only: [:create]
  def index
    @options = Option.all
  end

  def show
  end

  def create
    @option = Option.new(set_params)
  end

  private

  def set_option
    @option = Option.find(params[:id])
  end

  def set_params
    params.require(:option).permit(:origin, :destination, :cost, :start_time, :end_time, :duration)
  end
end
