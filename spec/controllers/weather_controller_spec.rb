# spec/controllers/weather_controller_spec.rb
require 'rails_helper'

RSpec.describe WeatherController, type: :controller do
  let(:location) { Location.create(uuid: '12345', location_name: 'Location') }
  describe 'GET #current' do
  
    it 'returns current weather' do
      allow(WeatherApi::CurrentWeatherFetcher).to receive(:call).and_return([{ 'Temperature' => { 'Metric' => { 'Value' => 25.0 } } }])
      get :current, params: { location_key: 'some_location_key' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(25.0)
    end
  end

  describe 'GET #historical' do
    it 'returns historical temperature records' do
      allow(TemperatureRecords::List).to receive(:call).and_return([
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 20.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now - 1.day, value: 17.0)
      ])
      get :historical, params: { location_key: 'some_location_key' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq([
        { Time.now.utc.to_s => '20.0' },
        { (Time.now.utc - 1.day).to_s => '17.0' }
      ])
    end
  end

  describe 'GET #max' do
    it 'returns maximum temperature' do
      allow(TemperatureRecords::List).to receive(:call).and_return([
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 20.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 22.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 24.0)
      ])
      get :max, params: { location_key: 'some_location_key' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq('24.0')
    end
  end

  describe 'GET #min' do
    it 'returns minimum temperature' do
      allow(TemperatureRecords::List).to receive(:call).and_return([
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 20.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 22.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 24.0)
      ])
      get :min, params: { location_key: 'some_location_key' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq('20.0')
    end
  end

  describe 'GET #avg' do
  let(:temperature_records_array) do
    [
      TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 20.0),
      TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 22.0),
      TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 24.0)
    ]
  end
    it 'returns average temperature' do
      record_ids = temperature_records_array.map(&:id)
      temperature_records_relation = TemperatureRecord.where(id: record_ids)

      allow(TemperatureRecords::List).to receive(:call).and_return(temperature_records_relation)
      get :avg, params: { location_key: 'some_location_key' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq('22.0')
    end
  end

  describe 'GET #by_time' do
    it 'returns temperature by timestamp' do
      timestamp = DateTime.now.to_i
      allow(FindWeatherByTime).to receive(:call).and_return(25.0)
      get :by_time, params: { location_key: 'some_location_key', timestamp: timestamp }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(25.0)
    end
  end
end
