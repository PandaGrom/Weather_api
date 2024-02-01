require 'rails_helper'

RSpec.describe FindWeatherByTime do
  describe '#call' do
    let(:location_key) { '12345' }
    let(:timestamp) { Time.now.to_i }

    context 'when location is found' do
      let!(:existing_location) { Location.create(uuid: location_key, location_name: 'Location') }
      let!(:temperature_records) do
        [
          TemperatureRecord.create(location: existing_location, observation_time: Time.at(timestamp - 3600), value: 20.0),
          TemperatureRecord.create(location: existing_location, observation_time: Time.at(timestamp), value: 17.0),
          TemperatureRecord.create(location: existing_location, observation_time: Time.at(timestamp + 3600), value: 30.0)
        ]
      end

      before do
        allow(TemperatureRecords::List).to receive(:call).with(location_key).and_return(existing_location.temperature_records)
      end

      it 'returns the weather value for the specified timestamp' do
        result = FindWeatherByTime.new(location_key, timestamp).call
        expect(result).to eq(17.0)
      end
    end
  end
end
