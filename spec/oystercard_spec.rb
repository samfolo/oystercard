require 'oystercard'

RSpec.describe Oystercard do
  let(:test_oystercard) { Oystercard.new }
  let(:empty_oystercard) { Oystercard.new }
  let(:entry_station) { double(:station, name: :canada_water, zone: 2) }
  let(:exit_station) { double(:station, name: :green_park, zone: 4) }
  let(:entry_station2) { double(:station, name: :liverpool_street, zone: 1) }
  let(:exit_station2) { double(:station, name: :mayfair, zone: 5) }

  let(:test_journey) { double(:journey, entry_station: entry_station, exit_station: exit_station, min_fare: 1, penalty_fare: 6) }

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

    it 'cannot be topped up an amount which will exceed the maximum balance' do
      expect { test_oystercard.top_up(81) }.to raise_error { Oystercard::TOP_UP_EXCEEDS_MAX_LIMIT }
    end
  end

  describe '#touch_in' do
    context 'when user has not touched out on last journey' do
      it 'should charge a penalty fare' do
        test_oystercard.touch_in(entry_station)

        expect { test_oystercard.touch_in(entry_station) }.to change { test_oystercard.balance }.by -6
      end
    end
  end

  describe '#touch_out' do
    context 'when user touches in before' do
      it 'should deduct the minumum fare' do
        test_oystercard.touch_in(entry_station)

        expect { test_oystercard.touch_out(exit_station) }.to change { test_oystercard.balance }.by -3
      end
    end
    
    context 'when user fails to touch in before' do
      it 'should charge a penalty fare' do
        expect { test_oystercard.touch_out(exit_station) }.to change { test_oystercard.balance }.by -test_journey.penalty_fare
      end
    end
  end

  context 'when fare is too low' do
    it 'prevents use on a journey' do
      expect { empty_oystercard.touch_in(entry_station) }.to raise_error { Oystercard::INSUFFICIENT_FUNDS }
    end
  end

  describe '#print_list_of_journeys' do
    it 'prints the current list of journeys with name and zone' do
      test_oystercard.touch_in(entry_station)
      test_oystercard.touch_out(exit_station)

      expect(test_oystercard.print_list_of_journeys.first).to eq 'Journey 1: Canada Water (Zone 2) to Green Park (Zone 4)'
    end
  end

  context 'when a journey crosses zones' do
    it 'charges 3 pounds for a journey spanning zones 2 and 4' do
      test_oystercard.touch_in(entry_station)

      expect { test_oystercard.touch_out(exit_station) }.to change { test_oystercard.balance }.by -3
    end

    it 'charges 5 pounds for a journey spanning zones 1 and 5' do
      test_oystercard.touch_in(entry_station2)

      expect { test_oystercard.touch_out(exit_station2) }.to change { test_oystercard.balance }.by -5
    end
    
    it 'charges minimum fare (£1) for a journey within the same zone' do
      test_oystercard.touch_in(entry_station2)

      expect { test_oystercard.touch_out(entry_station2) }.to change { test_oystercard.balance }.by -test_oystercard.min_fare
    end
  end
end