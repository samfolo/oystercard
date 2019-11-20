class Oystercard
  attr_reader :balance

  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'

  def initialize
    @balance = 0
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    @balance += amount
  end
end