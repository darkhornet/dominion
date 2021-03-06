class GameCreator

  attr_accessor :game

  def initialize(player_ids, proposer)
    @player_ids = player_ids
    @proposer = proposer
  end

  def create
    @game = Game.create proposer_id: @proposer
    add_players
    add_game_cards
    add_player_decks
    draw_hands
    TurnChanger.new(@game).first_turn
    @game.reload
  end

  private

  def add_players
    players = Player.where id: @player_ids
    players.update_all current_game: @game.id
    players.shuffle.each_with_index do |player, index|
      GamePlayer.create(game_id: @game.id, player_id: player.id, turn_order: index+1, victory_tokens: 0)
    end
  end

  def add_game_cards
    %w[kingdom victory treasure miscellaneous].each do |card_type|
      send("#{card_type}_cards").each do |card|
        GameCard.create(game_id: @game.id, card_id: card.id, remaining: card.starting_count(@game))
      end
    end
  end

  def add_player_decks
    cards = starting_deck
    @game.game_players.each do |player|
      cards.shuffle.each_with_index do |card, index|
        PlayerCard.create(game_player_id: player.id, card_id: card.id, card_order: index+1, state: 'deck')
      end
    end
  end

  def draw_hands
    @game.game_players.each do |player|
      CardDrawer.new(player).draw(5, false)
    end
  end

  def kingdom_cards
    Card.card_type(:kingdom).shuffle.take(10)
  end

  def victory_cards
    cards = %w[estate duchy province]
    cards << 'colony' if prosperity_game?
    Card.card_name(cards)
  end

  def treasure_cards
    cards = %w[copper silver gold]
    cards << 'potion' if @game.has_potions?
    cards << 'platinum' if prosperity_game?
    Card.card_name(cards)
  end

  def miscellaneous_cards
    [Card.by_name('curse')]
  end

  def starting_deck
    ([Card.by_name('estate')]*3) + ([Card.by_name('copper')]*7)
  end

  def prosperity_game?
    @prosperity_game ||= @game.cards_by_set('prosperity').count > random_number
  end

  def random_number
    @random_number ||= (rand 10) + 1
  end

end
