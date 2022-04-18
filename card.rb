class Card
    attr_reader :suit, :name, :abbr_name
    attr_accessor :value
    def initialize(name,  suit)
        @suit = suit
        @name = name
        self.value = card_value_hash[name.upcase]
        if ["JACk", "QUEEN", "KING", "ACE"].include?(name.upcase)
            @abbr_name = "#{name[0].upcase}#{suit[0].downcase}"
        else
            @abbr_name = "#{value}#{suit[0].downcase}"
        end
    end

    private

    def card_value_hash
        {
            "ONE" => 1,
            "TWO" => 2,
            "THREE" => 3,
            "FOUR" => 4,
            "FIVE" => 5,
            "SIX" => 6,
            "SEVEN" => 7,
            "EIGHT" => 8,
            "NINE" => 9,
            "TEN" => 10,
            "JACK" => 10,
            "QUEEN" => 10,
            "KING" => 10,
            "ACE" => 11
        }
    end

end