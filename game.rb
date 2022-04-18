require "securerandom"
class Game 
    attr_reader :player, :dealer
    attr_accessor :card_sleeve
    def initialize
        @player = Player.new(1)
        @dealer = Player.new(2, player_type: "Dealer")
        self.card_sleeve = []
        6.times { self.card_sleeve.push(Deck.new.cards)}
        self.card_sleeve.flatten!
        self.card_sleeve.shuffle!(random: SecureRandom)
    end

    def initial_deal
        2.times {
            self.player.add_card(self.card_sleeve.shift)
            self.dealer.add_card(self.card_sleeve.shift)
        }
    end

    def hit(p)
        p.add_card(self.card_sleeve.shift)
    end

    def reset_round
        self.player.hand = []
        self.dealer.hand = []
    end

    def game_status
        if self.card_sleeve.count > 2 * 52
             "CONTINUE"
        else
            "GAME END"
        end
    end

    def round_outcome
        if self.player.hand_status == "BUST"
            "DEALER WIN"
        elsif self.dealer.hand_status == "BUST"
            "PLAYER WIN"
        elsif self.player.hand_status == "BLACKJACK"
            "PLAYER WIN"
        else 
            if self.player.hand_value == self.dealer.hand_value
                "PUSH"
            elsif self.player.hand_value > self.dealer.hand_value
                "PLAYER WIN"
            else 
                "DEALER WIN"
            end
        end
    end

    def round_end
        if self.player.hand_status == "BLACKJACK"
            true
        elsif self.player.hand_status == "BUST" || self.dealer.hand_status == "BUST"
            true
        elsif ['BLACKJACK', 'HOLD'].include?(self.player.hand_status) && ['BLACKJACK', 'HOLD'].include?(self.dealer.hand_status)
            true
        else
            false
        end
    end

    def play_round
        #deal initial and check if player gets blackjack
        self.initial_deal
        return print_round_outcome if self.round_end
        while(self.player.hand_status == "HIT")
            self.hit(self.player)
        end
        #check to see if player busted, let dealer go if not
        return print_round_outcome if self.round_end
        while(self.dealer.hand_status == "HIT")
            #puts self.dealer.hand.map{|c| c.abbr_name}.to_s
            self.hit(self.dealer)
        end
        puts "Finished dealer status"
        #determine winner now that both player and dealer dealt
        return print_round_outcome
    end

    def play_full_game
        while(self.game_status == "CONTINUE")
            puts "\n\n\n"
            self.play_round
            self.reset_round
        end
    end

    def print_round_outcome
        puts self.round_outcome
        puts self.player.hand_printout
        puts self.dealer.hand_printout
    end
end