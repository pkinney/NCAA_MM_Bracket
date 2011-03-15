require "rspec"
require "team"
require "tournament"

describe "Tournament" do

  before(:each) do
    @teams = {}
    for i in 1..64 do
      @teams[i] = Team.new(i, "Team #{i}")
    end

    @first_round = []
    for i in 1..32 do
      g = TourneyGame.new()
      g.set_teams(@teams[i*2-1], @teams[i*2])
      @first_round << g
    end
  end

  it "should build a tournament from a list of first-round games" do
    tourney = Tournament.from_first_round(@first_round)
#    tourney.print_tourney
    tourney.final_game.should_not be_nil
  end

  it "should have a tournament built that involves all the root games" do
    tourney = Tournament.from_first_round(@first_round)
    tourney.final_game.should_not be_nil
    new_tourney = Tournament.from_final_game(tourney.final_game)
    new_tourney.print_tourney
#    new_tourney.first_round.should include(@first_round)
  end
end