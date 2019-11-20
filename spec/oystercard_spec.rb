require 'oystercard'

RSpec.describe Oystercard do
  let(:test_oystercard) { Oystercard.new }
  let(:empty_oystercard) { Oystercard.new }
  let(:entry_station) { double(:station, name: :canada_water, zone: 1) }
  let(:exit_station) { double(:station, name: :green_park, zone: 2) }
  let(:test_journey) { double(:journey, entry_station: entry_station, exit_station: exit_station) }

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

  describe '#touch_in' do
    context 'when user has touched in and out on last journey' do
      it 'should charge a penalty fare' do
        test_oystercard.touch_in(entry_station)

        expect { test_oystercard.touch_in(entry_station) }.to change { test_oystercard.balance }.by -Oystercard::PENALTY_FARE
      end
    end
  end

  describe '#touch_out' do
    context 'when user touches in before' do
      it 'should deduct the minumum fare' do
        test_oystercard.touch_in(entry_station)

        expect { test_oystercard.touch_out(exit_station) }.to change { test_oystercard.balance }.by -Oystercard::MINIMUM_CREDIT
      end
    end
    
    context 'when user fails to touch in before' do
      it 'should charge a penalty fare' do
        expect { test_oystercard.touch_out(exit_station) }.to change { test_oystercard.balance }.by -Oystercard::PENALTY_FARE
      end
    end
  end

  context 'when credit is too low' do
    it 'prevents use on a journey' do
      expect { empty_oystercard.touch_in(entry_station) }.to raise_error { Oystercard::INSUFFICIENT_FUNDS }
    end
  end

  describe '#print_list_of_journeys' do
    it 'prints the current list of journeys with name and zone' do
      test_oystercard.touch_in(entry_station)
      test_oystercard.touch_out(exit_station)

      expect(test_oystercard.print_list_of_journeys.first).to eq 'Journey 1: Canada Water (zone 1) to Green Park (zone 2)'
    end
  end
end