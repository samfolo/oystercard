require "station"

RSpec.describe Station do
  let(:station) { Station.new("Liverpool Street", 2) }

  describe "#name" do
    it "returns the station's name" do
      expect(station.name).to eq "Liverpool Street"
    end
  end

  describe "#zone" do
    it "returns the station's zone" do
      expect(station.zone).to eq 2
    end
  end

end