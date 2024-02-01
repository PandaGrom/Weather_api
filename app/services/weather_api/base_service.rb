module WeatherApi
  class BaseService < ApplicationService
    include HTTParty

    def initialize(location_key)
      @location_key = location_key
    end

    def call
      JSON.parse(response.body)
    end

    private
    
    attr_reader :location_key

    def request_path
      raise '#request_path should be implemented'
    end
    
    def response
      self.class.get(request_path, query: options)
    end

    def options
      { apikey: ENV['apikey'] }
    end
  end
end
