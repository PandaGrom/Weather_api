module TemperatureRecords
  class BatchCreate < ApplicationService
    def initialize(batch, location)
      @batch = batch
      @location = location
    end

    def call
      batch.each do |temperature_record|
        TemperatureRecord.create!(
          location: location,
          value: temperature_record.dig('Temperature', 'Metric', 'Value'),
          observation_time: temperature_record['LocalObservationDateTime'].to_datetime
        )
      end
    end

    private

    attr_reader :batch, :location
  end
end
