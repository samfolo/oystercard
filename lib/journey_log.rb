require 'journey'

class JourneyLog
  def initialize(journey_class = Journey)
    @journey_history = []
    @journey_class = journey_class
    @current_journey = @journey_class.new
  end

  def start(entry_station)
    # print @current_journey.exit_station.name
    @current_journey.register_entry_station(entry_station)
    @journey_history.push @current_journey
  end

  def finish(exit_station)
    @current_journey.register_exit_station(exit_station)
    current_journey
  end

  def journeys
    journey_list_to_display = []
    @journey_history.each_with_index do |journey, i|

      if journey.entry_station == nil
        entry_name = 'N/A'
        entry_zone = 'N/A'
      else
        entry_name = format_name(journey.entry_station.name)
        entry_zone = journey.entry_station.zone
      end

      if journey.exit_station == nil
        exit_name = 'N/A'
        exit_zone = 'N/A'
      else
        exit_name = format_name(journey.exit_station.name)
        exit_zone = journey.exit_station.zone
      end

      journey_list_to_display << "Journey #{i + 1}: #{entry_name} (zone #{entry_zone}) to #{exit_name} (zone #{exit_zone})"
    end
    journey_list_to_display
  end

  private

  def format_name(name)
    name.to_s.split('_').map { |word| word.capitalize }.join(' ')
  end

  def current_journey
    return @current_journey unless current_journey_complete?
    @current_journey = @journey_class.new
  end

  def current_journey_complete?
    @current_journey.complete_journey?
  end
end
