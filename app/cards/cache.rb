module Cache

  def starting_count(game)
    10
  end

  def cost(game)
    {
      coin: 5
    }
  end

  def type
    [:treasure]
  end

  def play(game)
    game.current_turn.add_coins(3)
  end

  def gain_event(game, player)
    copper = GameCard.by_game_id_and_card_name(game.id, 'copper').first
    card_gainer = CardGainer.new game, player, copper.id
    2.times do
      card_gainer.gain_card('discard')
    end
  end

end
