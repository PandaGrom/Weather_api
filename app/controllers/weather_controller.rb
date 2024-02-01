class WeatherController < ApplicationController
  def current
    render json: current_weather_data.first.dig("Temperature", "Metric", "Value")
  end

  def historical        
    render json: temperature_records.map { |record| { record.observation_time => record.value } }
  end

  def max    
    render json: temperature_records.pluck(:value).max
  end

  def min
    render json: temperature_records.pluck(:value).min
  end

  def avg
    render json: temperature_records.average(:value)
  end

  def by_time
    render json: FindWeatherByTime.call(resource_params[:location_key], resource_params[:timestamp])
  end

  private

  def temperature_records
    TemperatureRecords::List.call(resource_params[:location_key])
  end

  def current_weather_data
    WeatherApi::CurrentWeatherFetcher.call(resource_params[:location_key])
  end

  def resource_params
    params.permit(:location_key, :timestamp)
  end
end
