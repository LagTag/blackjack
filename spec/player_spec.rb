require "./player.rb"
describe Player do
    let(:player){Player.new(1)}
    let(:queen_of_spades){Card.new("Queen", "Spades")}
    let(:seven_of_diamonds){Card.new("SEVEN", "DIAMONDS")}
    let(:ace_of_spades){Card.new("ACE", "SPADES")}
    let(:ten_of_diamonds){Card.new("TEN", "DIAMONDS")}
    let(:three_of_hearts){Card.new("three", "Hearts")}

    describe "initialize" do
        it "returns player name" do
            expect(player.player_name).to eq("Player 1")
        end

        it "returns dealer" do
            dealer = Player.new(1, player_type: "dealer")
            expect(dealer.player_name).to eq("Dealer")
        end
    end

    describe "add_card" do 
        it "increases hand count of player" do 
            expect(player.hand.count).to eq(0)
            player.add_card(queen_of_spades)
            expect(player.hand.count).to eq(1)
        end
    end

    describe "hand_value" do
        it "returns total value of player hand" do 
            expect(player.hand_value).to eq(0)
            player.add_card(queen_of_spades)
            expect(player.hand_value).to eq(10)
            player.add_card(ace_of_spades)
            expect(player.hand_value).to eq(21)
        end

        it "adjusts ace to value of one if risk of busting" do 
            expect(player.hand_value).to eq(0)
            player.add_card(seven_of_diamonds)
            expect(player.hand_value).to eq(7)
            player.add_card(ace_of_spades)
            expect(player.hand_value).to eq(18)
            player.add_card(queen_of_spades)
            expect(player.hand_value).to eq(18)
        end
    end
    
    describe "hand_status" do
        it "is bust if hand value is greater than 21" do
            expect(player.hand_value).to eq(0)
            player.add_card(queen_of_spades)
            player.add_card(seven_of_diamonds)
            expect(player.hand_value).to eq(17)
            player.add_card(ten_of_diamonds)
            expect(player.hand_value).to eq(27)
            expect(player.hand_status).to eq("BUST")
        end
        it "is hold if value is 17 or greater" do
            player.add_card(ace_of_spades)
            player.add_card(seven_of_diamonds)
            expect(player.hand_status).to eq("HOLD")
        end

        it "is blackjack if initial hand is 21" do
            player.add_card(ace_of_spades)
            player.add_card(queen_of_spades)
            expect(player.hand_status).to eq("BLACKJACK")
        end

        it "is hit if value is less than 17" do
            player.add_card(ace_of_spades)
            player.add_card(three_of_hearts)
            expect(player.hand_status).to eq("HIT")
        end

        it "is hold if soft hand goes over 21" do
            player.add_card(ace_of_spades)
            player.add_card(seven_of_diamonds)
            player.add_card(ten_of_diamonds)
            expect(player.soft_hand).to be_truthy
            expect(player.hand_value).to eq(18)
            expect(player.hand_status).to eq("HOLD")
        end
    end
    describe "hand_printout" do
        it "prints out formatted hand" do 
            player.add_card(queen_of_spades)
            player.add_card(seven_of_diamonds)
            expect(player.hand_printout).to eq("Player 1 Hand\n--------\nQs (10)\n7d (7)\n--------\nTotal: 17\n\n")
        end
    end
end