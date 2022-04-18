require "./card.rb"
describe Card do
    describe "init" do 
        it "prints out card name" do
            card = Card.new("Queen", "Spades")
            expect(card.abbr_name).to eq("Qs")
            card = Card.new("Five", "Hearts")
            expect(card.abbr_name).to eq("5h")
        end
    end
end