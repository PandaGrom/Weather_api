require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location_name) { 'Test name' }
  let(:uuid) { '12345' }
  let(:location_new) { described_class.new(location_name:, uuid:) }

  context 'when location is valid' do
    it 'is valid with valid attributes' do
      expect(location_new).to be_valid
    end
  end

  context 'when location is invalid' do
    context 'when name is nil' do
      let(:location_name) { nil }

      it 'is not valid without a name' do
        expect(location_new).to_not be_valid
      end
    end

    context 'when uuid is duplicate' do
      let!(:score) { Location.create(location_name:, uuid: ) }
      let(:uuid) { '12345' }

      it 'is not valid with duplicate uuid' do
        expect(described_class.new(location_name:, uuid:)).to_not be_valid
      end
    end

    context 'when destroying location' do
      let(:location) { Location.create(location_name:, uuid:) }
      let!(:temperature_records) do
        [
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 20.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 22.0),
        TemperatureRecord.create(location: location, observation_time: DateTime.now, value: 24.0)
        ]
      end

      it 'destroys associated temperature_records when location is destroyed' do
        expect { location.destroy }.to change { location.temperature_records.count }.by(-3)
      end
    end
  end
end
