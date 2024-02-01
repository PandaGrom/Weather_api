require 'rails_helper'

RSpec.describe TemperatureRecords::BatchCreate do
  describe '#call' do
    let(:location) { Location.create(uuid: '12345', location_name: 'Location') }
    let(:batch) { [{ 'Temperature' => { 'Metric' => { 'Value' => 17.0 } }, 'LocalObservationDateTime' => DateTime.now.to_s }] }

    context 'when all passed correctly' do
      it 'creates temperature records for each item in the batch' do
        expect {
          TemperatureRecords::BatchCreate.call(batch, location)
        }.to change(TemperatureRecord, :count).by(1)

        created_record = TemperatureRecord.last
        expect(created_record.location).to eq(location)
        expect(created_record.value).to eq(17.0)
      end
    end

    context 'when an error occurs during creation' do
      before do
        allow(TemperatureRecord).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'raises an error' do
        expect {
          TemperatureRecords::BatchCreate.new(batch, location).call
        }.to raise_error(ActiveRecord::RecordInvalid)
      end

      context 'when batch is empty' do
        let(:empty_batch) { [] }

        it 'does not create any records for an empty batch' do
          expect {
            TemperatureRecords::BatchCreate.new(empty_batch, location).call
          }.not_to change(TemperatureRecord, :count)
        end
      end
    end
  end
end
