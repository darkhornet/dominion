class Province

  def starting_count(game)
    game.player_count == 2 ? 8 : 12
  end

  def cost
    8
  end

  def type
    [:victory]
  end

  def value(deck)
    6
  end
end