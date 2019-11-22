require 'journey_log'

RSpec.describe JourneyLog do
  let(:journey_class) { double(:Journey, new: test_journey) }
  let(:test_log) { JourneyLog.new(journey_class) }
  let(:test_journey)  { double(:journey, entry_station: nil, exit_station: nil) }
  let(:entry_station) { double(:station, name: :canada_water, zone: 1) }
  let(:exit_station) { double(:station, name: :green_park, zone: 2) }

  before(:each) do
    allow(test_journey).to receive(:register_entry_station)
    allow(test_journey).to receive(:register_exit_station)
    allow(test_journey).to receive(:complete_journey?)
  end

  describe 'at the start of a journey' do
    it 'registers a journey has started' do
      allow(test_journey).to receive(:entry_station).and_return(entry_station)
      test_log.start(entry_station)

      expect(test_log.journeys.first).to eq 'Journey 1: Canada Water (Zone 1) to N/A (Zone N/A)'
    end
  end

  describe 'at the end of a journey' do
    before(:each) do
      allow(test_journey).to receive(:entry_station).and_return(entry_station)
      allow(test_journey).to receive(:exit_station).and_return(exit_station, exit_station, exit_station, exit_station, nil)
    end

    it 'registers a journey has finished' do
      test_log.start(entry_station)
      test_log.finish(exit_station)
      
      expect(test_log.journeys.first).to eq 'Journey 1: Canada Water (Zone 1) to Green Park (Zone 2)'
    end

    it 'initialises a new journey' do
      test_log.start(entry_station)
      test_log.finish(exit_station)
      test_log.start(entry_station)

      expect(test_log.journeys).to eq(['Journey 1: Canada Water (Zone 1) to Green Park (Zone 2)',
                                       'Journey 2: Canada Water (Zone 1) to N/A (Zone N/A)'])
    end

    it 'saves journeys' do
    end
  end

  describe '#journeys' do
    it 'returns a list of journeys' do

    end
  end
end
