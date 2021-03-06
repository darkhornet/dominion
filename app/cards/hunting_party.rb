module HuntingParty

  def starting_count(game)
    10
  end

  def cost(game)
    {
      coin: 5
    }
  end

  def type
    [:action]
  end

  def play(game)
    @card_drawer = CardDrawer.new(game.current_player)
    @card_drawer.draw(1)
    game.current_turn.add_actions(1)
    @log_updater.get_from_card(game.current_player, '+1 action')

    reveal(game)
  end

  private

  def reveal(game)
    @revealed = []
    reveal_hand(game)
    reveal_cards(game)
    @log_updater.reveal(game.current_player, @revealed, 'deck')
    discard_revealed(game)
  end

  def reveal_hand(game)
    @hand = game.current_player.player_cards.hand
    @hand_names = @hand.map(&:name).uniq
    @log_updater.reveal(game.current_player, @hand, 'hand')
  end

  def reveal_cards(game)
    game.current_player.deck.each do |card|
      @revealed << card
      if unique_card?(card)
        @unique_card = card
        @unique_card.update_attribute :state, 'hand'
        break
      else
        card.update_attribute :state, 'revealed'
      end
    end

    continue_revealing(game) unless reveal_finished?(game)
  end

  def continue_revealing(game)
    game.current_player.shuffle_discard_into_deck
    reveal_cards(game)
  end

  def discard_revealed(game)
    game.current_player.discard_revealed
    @log_updater.put(game.current_player, [@unique_card], 'hand')
  end

  def reveal_finished?(game)
    @unique_card.present? || game.current_player.discard.count == 0
  end

  def unique_card?(card)
    @hand_names.select{ |name| name == card.name }.count == 0
  end

end
