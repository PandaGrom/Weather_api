require 'rails_helper'

RSpec.describe TemperatureRecord, type: :model do
  let(:location) { Location.create(location_name: 'Location', uuid: '12345') }
  let(:observation_time) { DateTime.now }
  let(:value) { 17.0 }
  let(:temperature_record) { described_class.new(location: location, observation_time: observation_time, value: value) }

  context 'when temperature_record is valid' do
    it 'is valid with valid attributes' do
      expect(temperature_record).to be_valid
    end
  end

  context 'when temperature_record is invalid' do
    context 'when location is nil' do
      let(:location) { nil }

      it 'is not valid without a location' do
        expect(temperature_record).to_not be_valid
      end

      it 'is not valid without an observation_time' do
        expect(temperature_record).to_not be_valid
      end

      it 'is not valid without a value' do
        expect(temperature_record).to_not be_valid
      end
    end
  end
end
