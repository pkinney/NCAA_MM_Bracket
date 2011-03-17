require "team"

class Team
  def num_games_won
    @games.count {|g| g.was_winner?(self)}
  end

  def num_games_lost
    @games.count {|g| !g.was_winner?(self)}
  end

  def ave_score
    @games.collect{|g| g.get_score(self).to_f}.inject(:+)/@games.size.to_f
  end

  def num_games_played
    @games.size
  end

  def win_percentage
    num_games_won.to_f/num_games_played.to_f
  end

  def cumulative_differential(levels = 1, decay = 1.0)
    @stored_diffs ||= {}
    dh = diff_hash(levels, decay)
    if @stored_diffs[dh]
      return @stored_diffs[dh]
    end
    total = calc_total_spread
    @games.each do |g|
      total += g.get_opponent(self).cumulative_differential(levels-1, decay).to_f*decay if levels > 1
    end
    @stored_diffs[dh] = total.to_f/num_games_played
  end

  private

  def calc_total_spread
    @total_spread ||= @games.collect{|g| g.spread_for(self).to_f}.inject(:+)
  end

  def diff_hash(levels, decay)
    levels+decay
  end
end