require 'rails_helper'

RSpec.describe WeatherApi::LocationFetcher do
  describe '#call' do
    let(:location_key) { '28580' }

    context 'when making a successful API request' do
      it 'returns parsed JSON response' do
        VCR.use_cassette('weather_api/location_fetcher_successful_request') do
          response = WeatherApi::LocationFetcher.call(location_key)
          
          expect(response).to have_key('EnglishName')
          expect(response['EnglishName']).to eq 'Minsk'
        end
      end
    end

    context 'when API request fails' do
      it 'returns an error' do
        VCR.use_cassette('weather_api/location_fetcher_failed_request') do
          response = WeatherApi::LocationFetcher.call('abc')
          expect(response).to eq nil
        end
      end
    end
  end
end
