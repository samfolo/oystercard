require 'oystercard'

RSpec.describe Oystercard do
  let(:test_oystercard) { Oystercard.new }
  let(:empty_oystercard) { Oystercard.new }
  let(:canada_water) { double(:station, name: :canada_water) }

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
      test_oystercard.touch_in(canada_water)

      expect(test_oystercard).to be_in_journey
    end

    it 'should know when it is not being used for a journey' do
      test_oystercard.touch_in(canada_water)
      test_oystercard.touch_out

      expect(test_oystercard).not_to be_in_journey
    end
  end

  context 'when touching out' do
    it 'should deduct the minumum fare' do
      test_oystercard.touch_in(canada_water)

      expect { test_oystercard.touch_out }.to change { test_oystercard.balance }.by -Oystercard::MINIMUM_CREDIT
    end
  end

  context 'when credit is too low' do
    it 'prevents use on a journey' do
      expect { empty_oystercard.touch_in(canada_water) }.to raise_error { Oystercard::INSUFFICIENT_FUNDS }
    end
  end

  context '#entry_station' do
    before(:each) do
      test_oystercard.touch_in(canada_water)
    end

    it 'remembers the entry station of a journey it is used for' do
      test_oystercard.touch_in(canada_water)

      expect(test_oystercard.entry_station).to be :canada_water
    end

    it 'forgets the entry station once a journey is complete' do
      test_oystercard.touch_out

      expect(test_oystercard.entry_station).to be_nil
    end
  end
end