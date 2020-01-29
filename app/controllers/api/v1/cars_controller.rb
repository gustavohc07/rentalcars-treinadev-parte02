class Api::V1::CarsController < Api::V1::ApiController
  def show
    @car = Car.find_by(id: params[:id])
    if @car
      render json: @car.as_json(methods: url_for(@car.photo))
    else
      head :not_found
    end
  end
  
  def index
    @cars = Car.all
    render json: @cars
  end

  def create
    @car = Car.new(car_params)
    if @car.valid?
      @car.save!
      render json: 'Created successfully', status: :created 
    else
      render json: { erro: "#{errors}"}, status: 412
    end
  end
  
  def update 
    @car = Car.find_by(id: params[:id] )
    @car.update(car_params)
    render json: 'Updated successfully', status: :ok

  end

  def destroy
    @car = Car.find_by(id: params[:id] )
    @car.delete
    render json: 'Deleted successfully', status: :ok
  end

  private
  def errors
     @car.errors.full_messages.each do |message|
      message
     end
  end

  def car_params
    params.permit(:car_km, :license_plate, :color,
                                :subsidiary_id, :car_model_id, :photo)
  end
end