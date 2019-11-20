require 'station'

RSpec.describe Station do
  let(:station) { Station.new('Liverpool Street', 2) }

  describe '#name' do
    it 'returns the name of the station' do
      expect(station.name).to eq 'Liverpool Street'
    end
  end

  describe '#zone' do
    it 'returns the zone of the station' do
      expect(station.zone).to eq 2
    end
  end
end