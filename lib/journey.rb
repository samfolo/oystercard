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

  def in_journey?
    !@entry_station.nil?
  end

  def complete_journey?
    @entry_station && @exit_station
  end

  def fare
    return 0 if !entry_station && !exit_station
    
    complete_journey? ? MINIMUM_FARE : PENALTY_FARE
  end
end