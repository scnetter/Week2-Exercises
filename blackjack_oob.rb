require 'pry'

BLACKJACK_AMOUNT = 21
DEALER_STAY_AMOUNT = 17


class CardHand
  attr_accessor :hand_owner, :hand_cards

  def initialize(hand_owner)
    @hand_cards = []
    @hand_owner = hand_owner
  end

  def is_busted?
    get_total > BLACKJACK_AMOUNT
  end
  
  def show_hand
    puts "#{hand_owner} has:"
    hand_cards.each_with_index do |card,index|
      puts card 
    end
    puts "=> Hand total is #{get_total}."
  end

  def show_flop
    puts "----- Dealer's Hand (First Card Hidden)------"
    puts "=> #{hand_cards[1]} is showing..."
  end

  def clear_hand
    self.hand_cards = []
  end

  def take_card(card)
    self.hand_cards << card
  end

  def get_total
    total = 0
    aces = 0
    face_values = hand_cards.map { |card| card.value }

    face_values.each do |value|
      if /A/.match(value)
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    face_values.select { |value| value == "A"}.count.times do
      break if total <=BLACKJACK_AMOUNT
      total -= 10
    end
    total
  end
end


class Deck
  attr_accessor :cards, :number_of_decks

  def initialize(number_of_decks=1)
    @number_of_decks = number_of_decks
    @cards = []
    card_values = %w[H D S C].product(%w[2 3 4 5 6 7 8 9 10 J Q K A])
    card_values.each do |suit_value_array|
      number_of_decks.to_i.times do
        @cards << Card.new(suit_value_array[0],suit_value_array[1])
      end
    end
    @cards.shuffle!
  end

  def deal
    cards.pop 
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(s,v)
    @suit = s
    @value = v
  end

  def to_s
    "The #{find_value} of #{find_suit}."
  end

  def find_suit
    case suit
    when 'H' then "\u2661 Hearts"
    when 'D' then "\u2662 Diamonds"
    when 'S' then "\u2664 Spades"
    when 'C' then "\u2667 Clubs"
    end
  end

  def find_value
    case value
    when 'K' then 'King'
    when 'Q' then 'Queen'
    when 'J' then 'Jack'
    when 'A' then 'Ace'
    else value
    end
  end
end

class Player
  def initialize(name)
    @name = name
    @hand = CardHand.new
  end
end

class BlackJack
  attr_accessor :deck, :player_hand, :dealer_hand

  def initialize
    @deck = nil
    @player_hand = []
    @dealer_hand = CardHand.new("Dealer")
  end

  def show_winner
    player_total = player_hand.get_total
    dealer_total = dealer_hand.get_total

    case 
    when player_total > BLACKJACK_AMOUNT
      puts "Dealer Wins - Player Bust"
    when dealer_total > BLACKJACK_AMOUNT
      puts "Player Wins! - Dealer Bust"
    when dealer_total == player_total
      puts "Tie! That's a push."  
    when dealer_total == BLACKJACK_AMOUNT
      puts "Dealer Wins! - Blackjack!"
    when player_total == BLACKJACK_AMOUNT
      puts "Player Wins! - Blackjack!"
    when dealer_total > player_total
      puts "Dealer Wins with #{dealer_total}. Player with #{player_total}"
    else
      puts "Player wins with #{player_total}. Dealer with #{dealer_total}"
    end
    play_again?
  end

  def renew_deck
    self.deck = Deck.new(number_of_decks)
  end

  def create_player_hand
    system('clear')
    puts "-----------Let's play BlackJack!--------------"
    puts "What's your name?"
    player_name = gets.chomp
    self.player_hand = CardHand.new(player_name)
  end

  def get_deck_num_and_create
    puts "How many decks do you want to play with?"
    number_of_decks = gets.chomp
    self.deck = Deck.new(number_of_decks)
  end

  def deal_cards
    2.times do
      player_hand.take_card(deck.deal)
      dealer_hand.take_card(deck.deal)
    end
  end

  def show_flop
    system('clear')
    player_hand.show_hand
    dealer_hand.show_flop
  end

  def player_turn
    loop do
      break if player_hand.get_total == BLACKJACK_AMOUNT
      puts "What would you like to do? 1) Hit 2) Stay:"
      hit_or_stay = gets.chomp
      if !['1','2'].include?(hit_or_stay)
        puts 'You must enter 1) to Hit or 2) to Stay'
        next
      elsif hit_or_stay == '1'
        player_hand.take_card(deck.deal)
        player_hand.show_hand
        player_hand.get_total >= BLACKJACK_AMOUNT ? break : dealer_hand.show_flop
      else
        player_hand.show_hand
        dealer_hand.show_hand
        break
      end
    end
  end

  def dealer_turn
    return if player_hand.get_total > BLACKJACK_AMOUNT

    until dealer_hand.get_total >= DEALER_STAY_AMOUNT ||  
      (player_hand.get_total == BLACKJACK_AMOUNT && 
        dealer_hand.get_total >= DEALER_STAY_AMOUNT)
      puts "Dealer draws. . ."
      sleep(2)
      dealer_hand.take_card(deck.deal)
      player_hand.show_hand
      dealer_hand.show_hand
    end
  end

  def play_again?
    puts "Do you want to play again? [Y/N]:"
    if gets.chomp.downcase == 'y'
      player_hand.clear_hand
      dealer_hand.clear_hand
      if deck.cards.length < (deck.number_of_decks.to_i * 52) / 2 
        print "Generating new deck. . ."
        self.deck = Deck.new(number_of_decks)
      end
      run
    else
      puts "Thanks for playing! Bye!"
      exit
    end
  end

  def run
  if deck.nil?
    create_player_hand
    get_deck_num_and_create 
  end
    deal_cards
    show_flop
    player_turn
    dealer_turn
    show_winner 
  end
end


BlackJack.new.run



