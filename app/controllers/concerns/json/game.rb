module Json::Game

  include Json::Helper

  def refresh_game_json(game, player)
    game_player = game.game_player(player.id)
    {
      action: 'refresh',
      kingdom_cards: game_cards(game, 'kingdom'),
      common_cards: common_cards(game),
      current_turn: game.current_turn,
      deck_count: game_player.deck.count,
      discard_count: game_player.discard.count,
      hand: sorted_hand(game_player),
      my_turn: same_player?(game.current_player.player, player)
    }.to_json
  end

end