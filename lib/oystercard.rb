class Oystercard
  attr_reader :balance, :credit_limit, :in_journey, :entry_station

  CREDIT_LIMIT = 90
  MINIMUM_CREDIT = 1
  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'
  TOP_UP_EXCEEDS_MAX_LIMIT = "topping up this amount will exceed the £#{ CREDIT_LIMIT } credit limit"
  INSUFFICIENT_FUNDS = "oystercard must have at least £#{ MINIMUM_CREDIT } to be used on a journey"

  def initialize
    @balance = 0
    @credit_limit = CREDIT_LIMIT
    @entry_station = nil
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    raise TOP_UP_EXCEEDS_MAX_LIMIT if amount + balance > credit_limit

    @balance += amount
  end

  def touch_in(station)
    raise INSUFFICIENT_FUNDS if balance < MINIMUM_CREDIT

    @entry_station = station.name
    @in_journey = true
  end

  def touch_out
    deduct(MINIMUM_CREDIT)
    @entry_station = nil
    @in_journey = false
  end

  def in_journey?
    !@entry_station.nil?
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end