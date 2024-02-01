module WeatherApi
  class LocationFetcher < BaseService
    private

    def request_path
      "http://dataservice.accuweather.com/locations/v1/#{location_key}"
    end
  end
end
