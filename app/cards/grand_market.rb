module GrandMarket

  def starting_count(game)
    10
  end

  def cost(game)
    {
      coin: 6
    }
  end

  def type
    [:action]
  end

  def allowed?(game)
    game.current_player.in_play.select{ |c| c.name == 'copper' }.count == 0
  end

  def play(game)
    market(game)
    game.current_turn.add_coins(2)
    @log_updater.get_from_card(game.current_player, '+1 action, +1 buy, and +$2')
  end

end
