class Player
  attr_accessor :name, :symbol

  def initialize(symbol, name = nil)
    @name = name
    @symbol = symbol
  end
end
