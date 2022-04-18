require "./game.rb"
require "./player.rb"
describe Game do
    let(:game){Game.new}
    let(:queen_of_spades){Card.new("Queen", "Spades")}
    let(:seven_of_diamonds){Card.new("SEVEN", "DIAMONDS")}
    let(:ace_of_spades){Card.new("ACE", "SPADES")}
    let(:ten_of_diamonds){Card.new("TEN", "DIAMONDS")}
    let(:three_of_hearts){Card.new("three", "Hearts")}
    let(:eight_of_clubs){Card.new("eight", "clubs")}

    describe "init" do
        it "creates a player and a dealer" do
            expect(game.player).to be_an_instance_of(Player)
            expect(game.dealer).to be_an_instance_of(Player)
            expect(game.dealer).not_to be(game.player)
        end

        it "creates a card sleeve with shuffled 6*52 cards" do
            expect(game.card_sleeve.count).to eq(6*52)
        end
    end


    describe "inital_deal" do
        it "removes 4 cards from card_sleeve" do 
            game.initial_deal
            expect(game.card_sleeve.count).to eq(6*52 - 4)
        end

        it "assigns two cards to player" do 
            game.initial_deal
            expect(game.player.hand.count).to eq(2)
        end

        it "assigns two cards to dealer" do 
            game.initial_deal
            expect(game.dealer.hand.count).to eq(2)
        end
    end

    describe "hit" do
        it "adds a card to player hand" do 
            game.initial_deal
            game.hit(game.player)
            expect(game.player.hand.count).to eq(3)
        end
        it "adds a card to dealer hand" do 
            game.initial_deal
            game.hit(game.dealer)
            expect(game.dealer.hand.count).to eq(3)
        end
    end

    describe "reset_round" do 
        it "removes cards from player and dealer hands" do 
            game.initial_deal
            game.reset_round
            expect(game.player.hand.count).to eq(0)
            expect(game.dealer.hand.count).to eq(0)
        end
    end

    describe "game_status" do 
        it "returns continue if more than 52*2 cards in sleeve" do 
            expect(game.game_status).to eq("CONTINUE")
        end

        it "returns 'GAME END' if <- 52*2 cards in sleeve" do 
            game.card_sleeve = game.card_sleeve[1..60]
            expect(game.game_status).to eq("GAME END")
        end
    end

    describe "round_outcome" do 
        it "determines player win if blackjack" do
            game.player.hand = [queen_of_spades, ace_of_spades]
            game.dealer.hand = [seven_of_diamonds, ten_of_diamonds]
            expect(game.round_outcome).to eq("PLAYER WIN")
        end
        it "determines dealer win if player busts" do 
            game.player.hand = [seven_of_diamonds, ten_of_diamonds, eight_of_clubs]
            game.dealer.hand = [seven_of_diamonds, ten_of_diamonds]
            expect(game.round_outcome).to eq("DEALER WIN")
        end
        it "determines player win if dealer busts" do 
            game.player.hand = [seven_of_diamonds, ten_of_diamonds]
            game.dealer.hand = [seven_of_diamonds, ten_of_diamonds, queen_of_spades]
            expect(game.round_outcome).to eq("PLAYER WIN")
        end

        it "determines push game if dealer and player have same hand value" do
            game.player.hand = [seven_of_diamonds, ten_of_diamonds]
            game.dealer.hand = [seven_of_diamonds, queen_of_spades]
            expect(game.round_outcome).to eq("PUSH")
        end

        it "determines player win if player has higher point total" do 
            game.player.hand = [eight_of_clubs, ten_of_diamonds]
            game.dealer.hand = [seven_of_diamonds, queen_of_spades]
            expect(game.round_outcome).to eq("PLAYER WIN")
        end

        it "determines dealer win if player has higher point total" do 
            game.player.hand = [seven_of_diamonds, ten_of_diamonds]
            game.dealer.hand = [eight_of_clubs, queen_of_spades]
            expect(game.round_outcome).to eq("DEALER WIN")
        end
    end

    describe "round_end" do 
        it "returns true if player blackjack" do 
            game.player.hand = [queen_of_spades, ace_of_spades]
            game.dealer.hand = [seven_of_diamonds, ten_of_diamonds]
            expect(game.round_end).to be_truthy
        end
        it "returns true if player busts" do 
            game.player.hand = [queen_of_spades, eight_of_clubs, seven_of_diamonds]
            game.dealer.hand = [seven_of_diamonds, ten_of_diamonds]
            expect(game.round_end).to be_truthy
        end
        it "returns true if dealer busts" do 
            game.player.hand = [queen_of_spades, three_of_hearts]
            game.dealer.hand = [queen_of_spades, eight_of_clubs, seven_of_diamonds]
            expect(game.round_end).to be_truthy
        end
        it "returns true if dealer && player hold" do 
            game.player.hand = [queen_of_spades, seven_of_diamonds]
            game.dealer.hand = [queen_of_spades, seven_of_diamonds]
            expect(game.round_end).to be_truthy
        end

        it "returns false if player hit" do 
            game.player.hand = [queen_of_spades, three_of_hearts]
            game.dealer.hand = [queen_of_spades, eight_of_clubs]
            expect(game.round_end).to be_falsy
        end

        it "returns false if player hold dealer hit" do 
            game.player.hand = [queen_of_spades, seven_of_diamonds]
            game.dealer.hand = [queen_of_spades, three_of_hearts]
            expect(game.round_end).to be_falsy
        end
    end

    describe "play_round" do 
        it "finishes if player gets blackjack" do 
            game.card_sleeve = [queen_of_spades, seven_of_diamonds, ace_of_spades, ten_of_diamonds, three_of_hearts, eight_of_clubs]
            game.play_round
            expect(game.card_sleeve.count).to eq(2)
            expect(game.round_outcome).to eq("PLAYER WIN")
        end

        it "finishes when player busts" do 
            game.card_sleeve = [queen_of_spades, seven_of_diamonds, three_of_hearts, ace_of_spades, ten_of_diamonds, eight_of_clubs]
            game.play_round
            expect(game.card_sleeve.count).to eq(1)
            expect(game.round_outcome).to eq("DEALER WIN")
        end

        it "finishes when dealer hits > 17" do 
            game.card_sleeve = [queen_of_spades, seven_of_diamonds, three_of_hearts, ace_of_spades, eight_of_clubs, ten_of_diamonds]
            game.play_round
            expect(game.card_sleeve.count).to eq(1)
            expect(game.round_outcome).to eq("PLAYER WIN")
        end
    end

    describe "play_full_game" do 
        it "does not play if card sleeve below 2*52 cards" do 
            game.card_sleeve = [queen_of_spades, seven_of_diamonds, three_of_hearts, ace_of_spades, eight_of_clubs, ten_of_diamonds]
            game.play_full_game
            expect(game.card_sleeve.count).to eq(6)
            expect(game.player.hand.count).to eq(0)
            expect(game.dealer.hand.count).to eq(0)
        end
        it "does not play if card sleeve below 2*52 cards" do 
            game.play_full_game
            expect(game.card_sleeve.count).to be <= 2*52
        end
    end
end