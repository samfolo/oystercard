require 'journey_log'

RSpec.describe JourneyLog do
  let(:journey_class) { double(:Journey, new: test_journey) }
  let(:test_log) { JourneyLog.new(journey_class) }
  let(:test_journey)  { double(:journey, entry_station: entry_station, exit_station: nil) }
  let(:entry_station) { double(:station, name: :canada_water, zone: 1) }
  let(:exit_station) { double(:station, name: :green_park, zone: 2) }

  before(:each) do
    allow(test_journey).to receive(:register_entry_station)
    allow(test_journey).to receive(:register_exit_station)
  end

  describe '#start' do
    it 'registers a journey has started' do
      test_log.start(entry_station)

      expect(test_log.journeys.first).to eq 'Journey 1: Canada Water (zone 1) to N/A (zone N/A)'
    end
  end

  describe '#finish' do
    it 'registers a journey has finished' do
      allow(test_journey).to receive(:exit_station).and_return(exit_station)
      test_log.start(entry_station)
      test_log.finish(exit_station)

      expect(test_log.journeys.first).to eq 'Journey 1: Canada Water (zone 1) to Green Park (zone 2)'
    end
  end

  describe '#journeys' do
    it 'returns a list of journeys' do

    end
  end
end
