require 'rails_helper'

RSpec.describe LatestTemperatureRecordsWorker, type: :worker do
  describe '#perform' do
  subject(:worker) { described_class.new }
    it 'enqueues a job' do
      allow(WeatherApi::HistoricalWeatherFetcher).to receive(:call).and_return([])

      expect { described_class.perform_async }.to change(described_class.jobs, :size).by(1)
    end
  end
end
