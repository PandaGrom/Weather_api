module TemperatureRecords
  class List < ApplicationService
    def initialize(location_key)
      @location_key = location_key
    end

    def call
      return found_location.temperature_records if found_location

      new_location = Locations::Create.call(new_location_args)
      TemperatureRecords::BatchCreate.call(weather_api_temperature_records, new_location)

      new_location.temperature_records
    end

    private

    attr_reader :location_key, :location

    def found_location
      @found_location ||= Location.find_by(uuid: location_key)
    end

    def new_location_args
      { uuid: location_key, location_name: }
    end

    def weather_api_location
      WeatherApi::LocationFetcher.call(location_key)
    end
    
    def weather_api_temperature_records
      WeatherApi::HistoricalWeatherFetcher.call(location_key)
    end

    def location_name
      weather_api_location.dig("EnglishName")
    end
  end
end
