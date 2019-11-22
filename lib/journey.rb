class Journey
  attr_reader :entry_station, :exit_station

  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  def register_entry_station(station)
    @entry_station = station
  end

  def register_exit_station(station)
    @exit_station = station
  end

  def complete_journey?
    @entry_station && @exit_station
  end

  def fare
    return 0 unless entry_station || exit_station

    complete_journey? ? MINIMUM_FARE + zone_charge : PENALTY_FARE
  end

  private

  def zone_charge
    entry_zone = entry_station.nil? ? 0 : entry_station.zone
    exit_zone = exit_station.nil? ? 0 : exit_station.zone
    (entry_zone - exit_zone).abs
  end
end