class Api::V1::CarsController < Api::V1::ApiController
  def show
    @car = Car.find_by(id: params[:id])
    if @car
      render json: @car
    else
      head :not_found
    end
  end
  
  def index
    @cars = Car.all
    render json: @cars
  end
end