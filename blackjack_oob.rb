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

class CardHand
  attr_accessor :hand_owner, :cards

  def initialize(hand_owner)
    @cards = []
    @hand_owner = hand_owner
  end

  def show_hand
    print "#{hand_owner} has "
    cards.each do |card|
      print "#{card.suit} #{card.value}, "
    end
    puts " with a total of #{get_total}."
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
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].product(['2','3','4','5','6','7','8','9','10','J','Q','K','A']).each do |suit_value_array|
      @cards << Card.new(suit_value_array[0],suit_value_array[1])
    end
    @cards.shuffle!
  end

  def deal(card_hand)
    card_hand.cards << self.cards.pop 
  end
end

class Card
  attr_accessor :suit, :value

  def initialize(s,v)
    @suit = s
    @value = v
  end
end

puts "-----------Let's play BlackJack!--------------"
puts "What's your name?"
player_name = gets.chomp

begin

  deck = Deck.new
  player_hand = CardHand.new(player_name)
  dealer_hand = CardHand.new("Dealer")

  2.times do
    deck.deal(player_hand)
    deck.deal(dealer_hand)
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
      deck.deal(player_hand)
      player_hand.show_hand
      player_hand.get_total >= 21 ? break : next
    else
      player_hand.show_hand
      break
    end
  end


  dealer_hand.show_hand
  unless player_hand.get_total > 21 || 
    (player_hand.get_total == 21 && dealer_hand.get_total >= 17)
    until dealer_hand.get_total >= 17
      puts "Dealer draws. . ."
      deck.deal(dealer_hand)
      dealer_hand.show_hand
    end
  end
  show_winner(dealer_hand,player_hand)
  puts "Do you want to play again? [Y/N]:"

end until gets.chomp.downcase != 'y'



