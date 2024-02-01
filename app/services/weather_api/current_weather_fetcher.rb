module WeatherApi
  class CurrentWeatherFetcher < BaseService
    private

    def request_path
      "http://dataservice.accuweather.com/currentconditions/v1/#{location_key}"
    end
  end
end
