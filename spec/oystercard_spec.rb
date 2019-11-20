require 'oystercard'

RSpec.describe Oystercard do
  it 'at first has a balance of 0' do
    expect(subject.balance).to be 0
  end
end