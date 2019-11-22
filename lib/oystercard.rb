require 'journey'
require 'journey_log'

class Oystercard
  attr_reader :balance, :credit_limit, :journey, :journey_log, :min_fare

  CREDIT_LIMIT = 90
  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'
  TOP_UP_EXCEEDS_MAX_LIMIT = "topping up this amount will exceed the £#{ CREDIT_LIMIT } credit limit"
  INSUFFICIENT_FUNDS = "oystercard must have at least £#{ @min_fare } to be used on a journey"

  def initialize(min_fare = Journey::MINIMUM_FARE, penalty_fare = Journey::PENALTY_FARE, journey = Journey.new, journey_log = JourneyLog.new)
    @balance      = 0
    @credit_limit = CREDIT_LIMIT
    @journey_log  = journey_log
    @min_fare     = min_fare
    @penalty_fare = penalty_fare
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    raise TOP_UP_EXCEEDS_MAX_LIMIT if amount + balance > credit_limit

    @balance += amount
  end

  def touch_in(entry_station)
    deduct(journey_log.journey.fare)
    raise INSUFFICIENT_FUNDS if balance < min_fare

    @journey_log.start(entry_station)
  end

  def touch_out(exit_station)
    @journey_log.finish(exit_station)
    deduct(journey_log.journey.fare)
  end

  def print_list_of_journeys
    journey_log.journeys
  end

  private

  def deduct(amount)
    @balance -= amount
  end
end