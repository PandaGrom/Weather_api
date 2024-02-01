require 'rails_helper'

RSpec.describe TemperatureRecords::List do
  describe '#call' do
    let(:location_key) { '12345' }
    let(:weather_api_location_response) { { 'EnglishName' => 'Location' } }
    let(:weather_api_temperature_records_response) { [{ 'Temperature' => { 'Metric' => { 'Value' => 17.0 } }, 'LocalObservationDateTime' => DateTime.now.to_s }] }

    before do
      allow(WeatherApi::LocationFetcher).to receive(:call).with(location_key).and_return(weather_api_location_response)
      allow(WeatherApi::HistoricalWeatherFetcher).to receive(:call).with(location_key).and_return(weather_api_temperature_records_response)
    end

    context 'when location is found' do
      let!(:existing_location) { Location.create(uuid: location_key, location_name: 'Location') }

      it 'returns temperature records of the found location' do
        result = TemperatureRecords::List.call(location_key)
        expect(result).to eq(existing_location.temperature_records)
      end
    end

    context 'when location is not found' do
      it 'creates a new location and returns its temperature records' do
        expect {
          result = TemperatureRecords::List.call(location_key)

          new_location = Location.find_by(uuid: location_key)
          expect(result).to eq(new_location.temperature_records)
          expect(new_location.location_name).to eq('Location')
        }.to change(Location, :count).by(1)
      end
    end
  end
end
