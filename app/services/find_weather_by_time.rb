class FindWeatherByTime < ApplicationService
  def initialize(location_key, timestamp)
    @location_key = location_key
    @timestamp = timestamp
  end

  def call
    TemperatureRecords::List.call(@location_key).sort_by { |record| (record.observation_time.to_i - @timestamp.to_i).abs }.first.value
  end
end
