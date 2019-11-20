require 'journey'

class Oystercard
  attr_reader :balance, :credit_limit, :in_journey, :entry_station, :list_of_journeys, :journey

  CREDIT_LIMIT = 90
  MINIMUM_CREDIT = 1
  PENALTY_FARE = 6
  NEGATIVE_TOP_UP_AMOUNT = 'cannot top up a negative amount'
  TOP_UP_EXCEEDS_MAX_LIMIT = "topping up this amount will exceed the £#{ CREDIT_LIMIT } credit limit"
  INSUFFICIENT_FUNDS = "oystercard must have at least £#{ MINIMUM_CREDIT } to be used on a journey"

  def initialize
    @balance = 0
    @credit_limit = CREDIT_LIMIT
    @journey = Journey.new
    @list_of_journeys = []
  end

  def top_up(amount)
    raise NEGATIVE_TOP_UP_AMOUNT unless amount > 0
    raise TOP_UP_EXCEEDS_MAX_LIMIT if amount + balance > credit_limit

    @balance += amount
  end

  def touch_in(entry_station)
    raise INSUFFICIENT_FUNDS if balance < MINIMUM_CREDIT
    
    fare
    @journey.register_entry_station(entry_station)
  end

  def touch_out(exit_station)
    @journey.register_exit_station(exit_station)
    store_journey(exit_station)
    fare
    @journey.reset_journey
  end

  def print_list_of_journeys
    journey_list_to_display = []
    @list_of_journeys.each_with_index do |journey, i|
      entry_name = format_name(journey[:entry_station].name)
      entry_zone = journey[:entry_station].zone
      exit_name = format_name(journey[:exit_station].name)
      exit_zone = journey[:exit_station].zone
      journey_list_to_display << "Journey #{i + 1}: #{entry_name} (zone #{entry_zone}) to #{exit_name} (zone #{exit_zone})"
    end
    journey_list_to_display
  end

  private

  def in_journey?
    @journey.in_journey?
  end

  def deduct(amount)
    @balance -= amount
  end

  def fare
    deduct(PENALTY_FARE) && return if @journey.entry_station && !@journey.exit_station

    @journey.entry_station && @journey.exit_station ? deduct(MINIMUM_CREDIT) : deduct(PENALTY_FARE)
  end

  def store_journey(exit_station)
    @list_of_journeys.push({ entry_station: @journey.entry_station, exit_station: @journey.exit_station })
  end

  def format_name(name)
    name.to_s.split('_').map { |word| word.capitalize }.join(' ')
  end
end