class Market

  def self.starting_count(game)
    10
  end

  def cost
    {
      coin: 5
    }
  end

  def type
    [:action]
  end

  def play
    # +1 card
    # +1 action
    # +1 buy
    # +1 coin
  end
end