require 'pry'

class BlackJack
  attr_accessor :deck, :player_hand, :dealer_hand

  def initialize(number_of_decks,player_name)
    @deck = Deck.new(number_of_decks)
    @player_hand = CardHand.new(player_name)
    @dealer_hand = CardHand.new("Dealer")
  end

  def show_winner(hand_one, hand_two)
    if hand_one.hand_owner == 'Dealer'
      dealer_total = hand_one.get_total
      player_total = hand_two.get_total
    else 
      dealer_total = hand_two.get_total
      player_total = hand_one.get_total
    end

    case 
    when player_total > 21
      puts "Dealer Wins - Player Bust"
      return
    when dealer_total > 21
      puts "Player Wins! - Dealer Bust"
      return
    when dealer_total == player_total
      puts "Dealer wins all ties - House Rules!!"
      return  
    when dealer_total == 21
      puts "Dealer Wins! - Blackjack!"
      return
    when player_total == 21
      puts "Player Wins! - Blackjack!"
      return
    when dealer_total > player_total
      puts "Dealer Wins with #{dealer_total}. Player with #{player_total}"
      return
    else
      puts "Player wins with #{player_total}. Dealer with #{dealer_total}"
    end
  end

  def renew_deck
    self.deck = Deck.new(number_of_decks)
  end

  def clear_hands
    self.player_hand.cards = []
    self.dealer_hand.cards = []
  end

  def run_game
    begin
      if deck.cards.length < (deck.number_of_decks.to_i * 52) / 2 
        print "Generating new deck. . ."
        self.deck = Deck.new(number_of_decks)
      end

      2.times do
        self.player_hand.cards << deck.deal
        self.dealer_hand.cards << deck.deal
      end

      player_hand.show_hand
      dealer_hand.show_hand

      loop do
        break if player_hand.get_total == 21
        puts "What would you like to do? 1) Hit 2) Stay:"
        hit_or_stay = gets.chomp
        if !['1','2'].include?(hit_or_stay)
          puts 'You must enter 1) to Hit or 2) to Stay'
          next
        elsif hit_or_stay == '1'
          player_hand.cards << deck.deal
          player_hand.show_hand
          player_hand.get_total >= 21 ? break : next
        else
          player_hand.show_hand
          break
        end
      end

      dealer_hand.show_hand
        
      until dealer_hand.get_total >= 17 || player_hand.get_total > 21 || 
        (player_hand.get_total == 21 && dealer_hand.get_total >= 17)
        puts "Dealer draws. . ."
        self.dealer_hand.cards << deck.deal
        dealer_hand.show_hand
      end
      show_winner(dealer_hand,player_hand)
      clear_hands
      puts "Do you want to play again? [Y/N]:"
    end until gets.chomp.downcase != 'y'
  end
end

class CardHand
  attr_accessor :hand_owner, :cards

  def initialize(hand_owner)
    @cards = []
    @hand_owner = hand_owner
  end

  def show_hand
    print "#{hand_owner} has "
    cards.each_with_index do |card,index|
      print card 
      index == cards.length - 1 ? (print " ") : (print " ,")
    end
    puts "with a total of #{get_total}."
  end

  def get_total
    total = 0
    aces = 0
    cards.each do |card| 
      if /[1-9]/.match(card.value)
        total += card.value.to_i 
      elsif /[JKQ]/.match(card.value)
        total += 10 
      elsif /A/.match(card.value)
        aces += 1 
      end
    end

    if (aces != 0) && (total < 11)
      total += (11 + aces - 1)   
    else
      total += aces
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
    "#{suit} #{value}"
  end
end

puts "-----------Let's play BlackJack!--------------"
puts "What's your name?"
player_name = gets.chomp
puts "How many decks do you want to play with?"
number_of_decks = gets.chomp
current_game = BlackJack.new(number_of_decks,player_name)
current_game.run_game



