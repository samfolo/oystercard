class Journey
  attr_reader :entry_station, :exit_station

  def register_entry_station(station)
    @entry_station = station
  end

  def register_exit_station(station)
    @exit_station = station
  end

  def reset_journey
    @entry_station = nil
    @exit_station = nil
  end

  def in_journey?
    !@entry_station.nil?
  end
end