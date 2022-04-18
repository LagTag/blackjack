class Player
    attr_reader :player_number, :player_type
    attr_accessor :hand
    def initialize(player_number, player_type: "regular")
        @player_number = player_number
        self.hand = []
        @player_type = player_type
    end

    def add_card(card)
        self.hand.push(card)
    end

    def hand_status
        if self.hand_value == 21 && self.hand.count == 2
            "BLACKJACK"
        elsif self.hand_value > 21
            "BUST"
        elsif self.hand_value >= 17
            "HOLD"
        else 
            "HIT"
        end
    end

    def soft_hand
        return self.hand.select{|c| c.name.upcase == "ACE" && c.value == 11}.count >= 1
    end

    def hand_value
        hv = self.hand.map{|c| c.value}.sum
        if hv > 21 && self.soft_hand
            aces = self.hand.select{|c| c.name.upcase == "ACE" && c.value == 11}
            aces.each do |a|
                hv -= 10
                a.value = 1
                break if hv < 21
            end
        end
        hv
    end

    def player_name
        if self.player_type.upcase == "DEALER"
            "Dealer"
        else
            "Player #{self.player_number}"
        end
    end

    def hand_printout
        s = "#{self.player_name} Hand\n--------\n"
        current_total = 0
        self.hand.each do |c|
            s += c.abbr_name
            card_value = c.value 
            s += " (#{card_value})\n"
        end
        s += "--------\nTotal: #{self.hand_value}\n\n"
    end
end