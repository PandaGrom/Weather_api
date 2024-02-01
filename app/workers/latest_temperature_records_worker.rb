class LatestTemperatureRecordsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :schedule

  def perform(*args)
    Location.all.each do |location|
      batch_records = WeatherApi::HistoricalWeatherFetcher.call(location.uuid)

      if location.temperature_records.empty?
        TemperatureRecords::BatchCreate.call(Array.wrap(batch_records), location)
      else
        latest_temperature_record = batch_records.first
        TemperatureRecords::BatchCreate.call(Array.wrap(latest_temperature_record), location)
        location.temperature_records.first.destroy
      end
    end
  end
end
