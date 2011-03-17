require "game"
require "team"

class TourneyGame
  attr_accessor :team1, :team2, :game1, :game2, :child, :name, :round

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

  def set_result(score_map)
    @team1_score = score_map[@team1]
    @team2_score = score_map[@team2]
  end

  def winner
    return nil unless @team1 && @team2 && @team1_score && @team2_score
    @team1_score > @team2_score ? @team1 : @team2
  end

  def loser
    return nil unless @team1 && @team2 && @team1_score && @team2_score
    winner == @team1 ? @team2 : @team1
  end

  def score_for(team)
    team == @team1 ? @team1_score : @team2_score
  end

  def to_s
    if @team1 && @team2
      "#{@name} - #{@team1.name} vs. #{@team2.name}"
    else
      "#{@name}"
    end
  end
end