class Deck 
    attr_accessor :cards
    def initialize
        self.cards = [] 
        ["Spade", "Club", "Heart", "Diamond"].each do |suit|
            ["TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "Jack", "Queen", "King", "Ace"].each do |value|
                c = Card.new(value, suit)
                self.cards.push(c)
            end
        end
    end
end