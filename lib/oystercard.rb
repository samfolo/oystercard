class Oystercard
  attr_reader :balance, :maximum_credit_limit

  MAXIMUM_CREDIT_LIMIT = 90
  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'
  TOP_UP_EXCEEDS_MAX_LIMIT = "topping up this amount will exceed the £#{MAXIMUM_CREDIT_LIMIT} credit limit"

  def initialize
    @balance = 0
    @maximum_credit_limit = MAXIMUM_CREDIT_LIMIT
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    raise TOP_UP_EXCEEDS_MAX_LIMIT if amount + balance > MAXIMUM_CREDIT_LIMIT

    @balance += amount
  end
end