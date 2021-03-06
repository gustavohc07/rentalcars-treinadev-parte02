require 'rails_helper'
  describe "Car management" do
    context 'show' do
      it 'renders a car correctly' do
        car = create(:car)
        car.photo.attach(io: File.open('spec/support/GTR.jpg'), filename: 'GTR.jpg', content_type: 'image/jpg' )
        
        get api_v1_car_path(car)
        pp response.body
        json = JSON.parse(response.body, symbolize_names: true)
        #pp json
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

        expect(response).to have_http_status(:ok)
        expect(json[0][:car_model_id]).to eq(car.car_model_id)    
        expect(json[0][:license_plate]).to eq(car.license_plate)    
        expect(json[0][:car_km]).to eq(car.car_km)    
        expect(json[0][:color]).to eq(car.color)    
        expect(json[0][:subsidiary_id]).to eq(car.subsidiary_id)

        expect(json[1][:car_model_id]).to eq(car2.car_model_id)    
        expect(json[1][:license_plate]).to eq(car2.license_plate)
        expect(json[1][:car_km]).to eq(car2.car_km)
        expect(json[1][:color]).to eq(car2.color)
        expect(json[1][:subsidiary_id]).to eq(car2.subsidiary_id)

        expect(json.size).to eq(2)
      end

      context 'create' do
        it 'create a car correctly' do
          subsidiary = create(:subsidiary)
          car_model = create(:car_model)

          post api_v1_cars_path, params: 
                                              {
                                                car_km: 1000,
                                                license_plate: 'ABC1234',
                                                color: 'Azul',
                                                subsidiary_id: subsidiary.id,
                                                car_model_id: car_model.id,
                                              }
          expect(response).to have_http_status(:created)
          expect(response.body).to include('Created successfully')

          car = Car.last                                         
          expect(car.car_km).to eq(1000)                                          
          expect(car.license_plate).to eq('ABC1234')                                          
          expect(car.color).to eq('Azul')
        end

        it 'should not create if missing parameter' do
          post api_v1_cars_path, params: {}

          json = JSON.parse(response.body)
          expect(response).to have_http_status(412)
          expect(json['erro']).to include('Modelo é obrigatório')

        end
        it 'should return status 500 if a unexpected error ocurred' do
          
          allow_any_instance_of(Car).to receive(:save!).and_raise(ActiveRecord::ActiveRecordError)
          subsidiary = create(:subsidiary)
          car_model = create(:car_model)
          
          post api_v1_cars_path, params: 
                                              {
                                                car_km: 1000,
                                                license_plate: 'ABC1234',
                                                color: 'Azul',
                                                subsidiary_id: subsidiary.id,
                                                car_model_id: car_model.id,
                                              }
          json = JSON.parse(response.body)
          expect(response).to have_http_status(500)
          expect(json["message"]).to eq('Unexpeted error')

        end

        it 'upload a car photo correctly' do
          subsidiary = create(:subsidiary)
          car_model = create(:car_model)

          post api_v1_cars_path, params: 
                                              {
                                                car_km: 1000,
                                                license_plate: 'ABC1234',
                                                color: 'Azul',
                                                subsidiary_id: subsidiary.id,
                                                car_model_id: car_model.id,
                                                photo: Rails.root.join('../support/GTR.jpg')
                                              }
          pp response.body
          expect(response).to have_http_status(:created)
          expect(response.body).to include('Created successfully')
         end
      end

      context 'update' do
        it 'should update car successfully' do
          car = create(:car, car_km: 1000, license_plate: 'ABC1234', color: 'Azul')

          put api_v1_car_path(car.id), params: {
                                              car_km: 20000,
                                              license_plate: 'DEF5678',
                                              color: 'Preto',
                                             }

         expect(response).to have_http_status(:ok)
         expect(response.body).to include('Updated successfully')
         car.reload
         
         expect(car.car_km).to eq(20000)
         expect(car.license_plate).to eq('DEF5678')
         expect(car.color).to eq('Preto')
        end
      end

      context 'delete' do
        it 'should delete car successfully' do
          car = create(:car, car_km: 1000, license_plate: 'ABC1234', color: 'Azul')

          delete api_v1_car_path(car.id)

          expect(response).to have_http_status(:ok)
          expect(response.body).to include('Deleted successfully')
          expect(Car.count).to eq (0)
        end
      end
    end
    
  end
  