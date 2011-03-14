require "rspec"
require "team"
require "game"

describe "Game Winner" do
  before(:each) do
    @team1 = Team.new(1, "Red")
    @team2 = Team.new(2, "Blue")
    @team3 = Team.new(3, "Yellow")

    @teams = {"1" => @team1, "2" => @team2, "3" => @team3}
  end

  it "should be equal to an identical game" do
    g1 = Game.new(Date.strptime("2001-02-03"), @team1, @team2, 20, 30)
    g2 = Game.new(Date.strptime("2001-02-03"), @team1, @team2, 20, 30)

    g1.should == g2
    g1.should == Game.new(Date.strptime("2001-02-03"), @team2, @team1, 30, 20)

    g1.should_not == Game.new(Date.strptime("2001-02-04"), @team1, @team2, 20, 30)
    g1.should_not == Game.new(Date.strptime("2001-02-03"), @team1, @team3, 20, 30)
    g1.should_not == Game.new(Date.strptime("2001-02-03"), @team1, @team2, 30, 20)
    g1.should_not == Game.new(Date.strptime("2001-02-03"), @team1, @team2, 21, 30)
  end

  it "should know the teams and their scores" do
    g = Game.new(Date.strptime("2001-02-03"))
    g.add_team(@team1)
    g.add_team(@team2)
    
    g.get_opponent(@team1).should == @team2
    g.get_opponent(@team2).should == @team1
    g.get_opponent(@team1).should_not == @team1
    g.get_opponent(@team2).should_not == @team2

    g.set_score(@team1, 20)
    g.set_score(@team2, 30)

    g.get_score(@team1).should == 20
    g.get_score(@team2).should == 30

    g.get_score_for_opponent(@team1).should == 30
    g.get_score_for_opponent(@team2).should == 20
  end

  it "should create a game in one initialization" do
    g = Game.new(Date.strptime("2001-02-03"), @team1, @team2, 20, 30)

    g.get_winner().should == @team2
    g.get_loser().should == @team1

    g.was_winner?(@team2).should == true
    g.was_winner?(@team1).should == false

    g.date.should == Date.strptime("2001-02-03")
  end

  it "should return the winner and loser of a non-tie game" do
    g = Game.new(Date.strptime("2001-02-03"))

    g.add_team(@team1)
    g.add_team(@team2)

    g.set_score(@team1, 20)
    g.set_score(@team2, 30)

    g.get_winner().should == @team2
    g.get_loser().should == @team1

    g.was_winner?(@team2).should == true
    g.was_winner?(@team1).should == false
  end

  it "should write and load games" do
    g1 = Game.new(Date.strptime("2001-02-03"), @team1, @team2, 20, 30)
    s = g1.to_save_string
    puts s
    puts Game.from_save_string(s, @teams).to_save_string
    Game.from_save_string(s, @teams).should == g1
  end
end