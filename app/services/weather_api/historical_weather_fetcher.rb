module WeatherApi
  class HistoricalWeatherFetcher < BaseService
    private

    def request_path
      "http://dataservice.accuweather.com/currentconditions/v1/#{location_key}/historical/24"
    end
  end
end
