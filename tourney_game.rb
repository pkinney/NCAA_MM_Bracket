require "game"
require "team"

class TourneyGame
  attr_accessor :team1, :team2, :game1, :game2, :child, :name, :round, :winner, :spread

  def initialize()
    @child = nil
  end

  def set_teams(t1, t2)
    @team1 = t1
    @team2 = t2
  end

  def set_parents(game1, game2)
    @game1 = game1
    @game2 = game2
    game1.child = self
    game2.child = self
  end

  def set_result(winning_team, score_spread)
    @winner=winning_team
    @spread=score_spread
  end

  def loser
    winner == team1 ? team2 : team1
  end

  def to_s
    if @team1 && @team2
      "#{@name} - #{@team1.name} vs. #{@team2.name}"
    else
      "#{@name}"
    end
  end
end