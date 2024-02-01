require 'rails_helper'

RSpec.describe WeatherApi::HistoricalWeatherFetcher do
  describe '#call' do
    let(:location_key) { '28580' }

    context 'when making a successful API request' do
      it 'returns parsed JSON response' do
        VCR.use_cassette('weather_api/historical_weather_fetcher_successful_request') do
          response = WeatherApi::HistoricalWeatherFetcher.call(location_key)
          expect(response.first).to have_key('LocalObservationDateTime')
        end
      end
    end

    context 'when API request fails' do
      it 'returns an error' do
        VCR.use_cassette('weather_api/historical_weather_fetcher_failed_request') do
          response = WeatherApi::HistoricalWeatherFetcher.call('abc')
          expect(response).to include('Code' => '400', 'Message' => 'Invalid location key: abc', "Reference" => "/currentconditions/v1/abc/historical/24")
        end
      end
    end
  end
end
