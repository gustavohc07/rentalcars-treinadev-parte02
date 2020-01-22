require 'rails_helper'
  describe "Car management" do
    context 'show' do
      it 'renders a car correctly' do
        car = create(:car)

        get api_v1_car_path(car)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:car_model_id]).to eq(car.car_model_id)    
        expect(json[:license_plate]).to eq(car.license_plate)    
        expect(json[:car_km]).to eq(car.car_km)    
        expect(json[:color]).to eq(car.color)    
        expect(json[:subsidiary_id]).to eq(car.subsidiary_id)
      end
      
      it 'car was not found' do
        get api_v1_car_path(id: 9999)

        expect(response).to have_http_status(:not_found)
          
      end
      
    end

    context 'index' do
      it 'render cars correctly' do
        car = create(:car)
        car2 = create(:car, car_km: 20000, license_plate: 'ABC0123')

        get api_v1_cars_path

        json = JSON.parse(response.body, symbolize_names: true)

        pp json
        expect(response).to have_http_status(:ok)
        expect(json[:car_model_id]).to eq(car.car_model_id)    
        expect(json[:license_plate]).to eq(car.license_plate)    
        expect(json[:car_km]).to eq(car.car_km)    
        expect(json[:color]).to eq(car.color)    
        expect(json[:subsidiary_id]).to eq(car.subsidiary_id)

        expect(json[:car_model_id]).to eq(car2.car_model_id)    
        expect(json[:license_plate]).to eq(car2.license_plate)    
        expect(json[:car_km]).to eq(car2.car_km)    
        expect(json[:color]).to eq(car2.color)    
        expect(json[:subsidiary_id]).to eq(car2.subsidiary_id)
      end
    end
    
  end
  