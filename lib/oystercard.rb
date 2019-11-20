class Oystercard
  attr_reader :balance, :maximum_credit_limit, :in_journey

  MAXIMUM_CREDIT_LIMIT = 90
  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'
  TOP_UP_EXCEEDS_MAX_LIMIT = "topping up this amount will exceed the £#{MAXIMUM_CREDIT_LIMIT} credit limit"

  def initialize
    @balance = 0
    @maximum_credit_limit = MAXIMUM_CREDIT_LIMIT
    @in_journey = false
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    raise TOP_UP_EXCEEDS_MAX_LIMIT if amount + balance > MAXIMUM_CREDIT_LIMIT

    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end
end