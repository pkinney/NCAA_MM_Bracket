require "game"
require "team"

class TourneyGame
  attr_accessor :team1, :team2, :parents, :child

  def initialize()
    @parents = []
    @child = nil
  end

  def set_teams(t1, t2)
    @team1 = t1
    @team2 = t2
  end

  def set_parents(game1, game2)
    @parents = [game1, game2]
  end

  def to_s
    if @team1 && @team2
      "#{@team1.name} vs. #{@team2.name}"
    else
      "game"
    end
  end
end