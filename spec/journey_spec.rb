require 'journey'

RSpec.describe Journey do
  let(:new_journey) { Journey.new }
  let(:entry_station) { double(:station, name: :canada_water, zone: 1) }
  let(:exit_station) { double(:station, name: :liverpool_street, zone: 2) }

  it 'remembers its entry station' do
    new_journey.register_entry_station(entry_station)

    expect(new_journey.entry_station).to eq entry_station
  end

  it 'remembers its exit station' do
    new_journey.register_exit_station(exit_station)

    expect(new_journey.exit_station).to eq exit_station
  end

  # describe '#fare' do
  #   it 'is charges the penalty amount at the end of an invalid journey' do
  #     new_journey.register_entry_station(entry_station)

  #     expect { new_journey.fare }.to 
  #   end
  # end

end