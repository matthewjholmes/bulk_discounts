class Holiday
  attr_reader :date,
              :name

  def initialize(attributes)
    @date         = attributes[:date]
    @name         = attributes[:name]
  end
end
