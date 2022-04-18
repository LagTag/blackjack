require "./deck.rb"
describe Deck do
    let(:deck){Deck.new}
    describe "initialize" do
        it "creates a deck of 52 cards" do
            expect(deck.cards.count).to eq(52)
        end
    end
end