require 'rails_helper'

RSpec.describe Locations::Create do
  describe '#call' do
    let(:args) { { uuid: '12345', location_name: 'Location' } }

    context 'when args passed correctly' do
      it 'creates a location with the given parameters' do
        expect {
          Locations::Create.new(args).call
        }.to change(Location, :count).by(1)

        created_location = Location.last
        expect(created_location.uuid).to eq('12345')
        expect(created_location.location_name).to eq('Location')
      end
    end

    context 'when an error occurs during creation' do
      before do
        allow(Location).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises an error' do
        expect {
          Locations::Create.new(args).call
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
