class Station

  attr_reader :name, :zone

  def initialize(name = nil, zone = nil)
    @name = name
    @zone = zone
  end

end