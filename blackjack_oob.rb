# 1. Write out requirements or specs
# 2. Extract major nouns => Classes
# 3. Extract major verbs => instance Methods
# 4. Group instance methods into classes

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].product(['2','3','4','5','6','7','8','9','10','J','Q','K','A']).each do |suit_value_array|
      @cards << Card.new(suit_value_array[0],suit_value_array[1])
    end
    @cards.shuffle!
  end

  def get_card_count
    cards.length
  end

  def deal(player)
    player.hand << @cards.pop 
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(s,v)
    @suit = s
    @value = v
  end

  def to_s()
    "#{suit} #{value}"
  end
end

class Player
  attr_accessor :name, :hand
  def initialize(name)
    @name = name
    @hand = []
  end

  def get_total

  end

  def show_hand
    hand.each do |card|
      puts card
    end
  end
end


deck = Deck.new
player1 = Player.new("Kelly")
deck.deal(player1)
player1.show_hand

puts deck.get_card_count
player1.hand
