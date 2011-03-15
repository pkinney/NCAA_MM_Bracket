require "team"

class Team
  def num_games_won
    @games.count {|g| g.was_winner?(self)}
  end

  def num_games_lost
    @games.count {|g| !g.was_winner?(self)}
  end

  def num_games_played
    @games.size
  end

  def win_percentage
    num_games_won.to_f/num_games_played.to_f
  end

  def cumulative_differential(levels = 1)
    total = 0
    @games.each do |g|
      total += g.spread_for(self)
      total += g.get_opponent(self).cumulative_differential(levels-1) if levels > 1
    end
    total.to_f/num_games_played
  end
end