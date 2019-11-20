require 'oystercard'

RSpec.describe Oystercard do
  let(:test_oystercard) { Oystercard.new }
  let(:empty_oystercard) { Oystercard.new }
  let(:entry_station) { double(:station, name: :canada_water, zone: 1) }
  let(:exit_station) { double(:station, name: :green_park, zone: 2) }

  before(:each) do
    test_oystercard.top_up(10)
  end

  it 'at first has a balance of 0' do
    expect(subject.balance).to be 0
  end

  context 'when topping up' do
    it 'increases the balance by £10 when topped up £10' do
      expect { test_oystercard.top_up(10) }.to change { test_oystercard.balance }.by 10
    end

    it 'increases the balance by £6 when topped up £6' do
      expect { test_oystercard.top_up(6) }.to change { test_oystercard.balance }.by 6
    end

    it 'cannot be topped up by a negative amount' do
      expect { test_oystercard.top_up }.to raise_error { Oystercard::NEGATIVE_TOP_UP_AMOUNT }
    end

    it 'cannot be topped up an amount which will exceed the maximum credit limit' do
      expect { test_oystercard.top_up(81) }.to raise_error { Oystercard::TOP_UP_EXCEEDS_MAX_LIMIT }
    end
  end

  context 'when in journey' do
    it 'should know when it is being used for a journey' do
      test_oystercard.touch_in(entry_station)

      expect(test_oystercard).to be_in_journey
    end

    it 'should know when it is not being used for a journey' do
      test_oystercard.touch_in(entry_station)
      test_oystercard.touch_out(exit_station)

      expect(test_oystercard).not_to be_in_journey
    end
  end

  context 'when touching out' do
    it 'should deduct the minumum fare' do
      test_oystercard.touch_in(entry_station)

      expect { test_oystercard.touch_out(exit_station) }.to change { test_oystercard.balance }.by -Oystercard::MINIMUM_CREDIT
    end
  end

  context 'when credit is too low' do
    it 'prevents use on a journey' do
      expect { empty_oystercard.touch_in(entry_station) }.to raise_error { Oystercard::INSUFFICIENT_FUNDS }
    end
  end

  describe '#entry_station' do
    before(:each) do
      test_oystercard.touch_in(entry_station)
    end

    it 'remembers the entry station of a journey it is used for' do
      test_oystercard.touch_in(entry_station)

      expect(test_oystercard.entry_station).to be entry_station
    end

    it 'forgets the entry station once a journey is complete' do
      test_oystercard.touch_out(exit_station)

      expect(test_oystercard.entry_station).to be_nil
    end

  end

  describe "#print_list_of_journeys" do
    it "prints the current list of journeys with name and zone" do
      test_oystercard.touch_in(entry_station)
      test_oystercard.touch_out(exit_station)
      expect(test_oystercard.print_list_of_journeys.first).to eq "Journey 1: Canada Water (zone 1) to Green Park (zone 2)"
    end
  end
end