class PlayerCard < ActiveRecord::Base
  belongs_to :game_player
  belongs_to :card

  scope :ordered, ->{ order 'card_order, card_id' }
  scope :deck, ->{ where state: 'deck' }
  scope :hand, ->{ where state: 'hand' }
  scope :in_play, ->{ where state: %w(play duration) }
  scope :duration, ->{ where state: 'duration' }
  scope :discard, ->{ where state: 'discard' }
  scope :revealed, ->{ where state: 'revealed' }

  def name
    card.name
  end

  def type_class
    card.type_class
  end

  def treasure?
    type_class.include? 'treasure'
  end

  def action?
    type_class.include? 'action'
  end

  def duration?
    type_class.include? 'duration'
  end

  def victory?
    type_class.include? 'victory'
  end

  def curse?
    type_class.include? 'curse'
  end

  def point_card?
    card.respond_to? :value
  end

  def value
    point_card? ? card.value(game_player.player_cards) : 0
  end

  def discard
    update_attribute(:state, 'discard')
  end

end
