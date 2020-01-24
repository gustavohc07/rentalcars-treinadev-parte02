class Api::V1::ApiController < ActionController::API
rescue_from ActiveRecord::ActiveRecordError, with: :database_error

private
  def database_error
    render json: { message: 'Unexpeted error'}, status: 500
  end
end