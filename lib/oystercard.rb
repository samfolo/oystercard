class Oystercard
  attr_reader :balance, :credit_limit, :in_journey, :entry_station, :list_of_journeys

  CREDIT_LIMIT = 90
  MINIMUM_CREDIT = 1
  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'
  TOP_UP_EXCEEDS_MAX_LIMIT = "topping up this amount will exceed the £#{ CREDIT_LIMIT } credit limit"
  INSUFFICIENT_FUNDS = "oystercard must have at least £#{ MINIMUM_CREDIT } to be used on a journey"

  def initialize
    @balance = 0
    @credit_limit = CREDIT_LIMIT
    @entry_station = nil
    @list_of_journeys = []
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    raise TOP_UP_EXCEEDS_MAX_LIMIT if amount + balance > credit_limit

    @balance += amount
  end

  def touch_in(entry_station)
    raise INSUFFICIENT_FUNDS if balance < MINIMUM_CREDIT

    @entry_station = entry_station.name
    @in_journey = true
  end

  def touch_out(exit_station)
    deduct(MINIMUM_CREDIT)
    store_journey(exit_station)
    @in_journey = false
    @entry_station = nil
  end

  def in_journey?
    !@entry_station.nil?
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def store_journey(exit_station)
    @list_of_journeys.push({ entry_station: entry_station, exit_station: exit_station.name })
  end
end