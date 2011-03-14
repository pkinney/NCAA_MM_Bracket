require 'date'

class Game
  attr_accessor :teams, :date

  def initialize(date=nil, team1=nil, team2=nil, score1=0, score2=0)
    @winner = nil
    @loser = nil
    @teams = []
    @scores = {}
    @date = date

    add_team(team1) if team1
    add_team(team2) if team2
    set_score(team1, score1) if team1&&score1
    set_score(team2, score2) if team2&&score2
  end

  def add_team(team)
    @teams << team unless @teams.include?(team)
  end

  def played?(team)
    @teams.includes? team
  end

  def get_opponent(team)
    @teams.select{|t| t != team}.first
  end

  def set_score(team, score)
    add_team(team)
    @scores[team] = score
  end

  def get_score(team)
    @scores[team]
  end

  def get_score_for_opponent(team)
    get_score(get_opponent(team))
  end

  def get_winner()
    find_winner_loser unless @winner && @loser
    @winner
  end

  def get_loser()
    find_winner_loser unless @winner && @loser
    @loser
  end

  def was_winner? (team)
    get_winner == team
  end

  def was_loser? (team)
    get_loser == team
  end

  def to_s
    "#{date} - #{@teams.collect{|t| "#{t.name}: #{get_score(t)}"}.join(" vs. ")}"
  end

  def == (og)
    if og.date!=date || @teams.size != og.teams.size
      false
    else
      @teams.each do |t|
        if og.get_score(t) != get_score(t)
          return false
        end
      end
      true
    end
  end

  def to_save_string
    "#{@date}|#{@teams.collect{|t| "#{t.team_id}:#{get_score(t)}"}.join("|")}"
  end

  def self.from_save_string(s, team_id_to_team_map)
    tokens = s.split "|"
    d = tokens.shift
    g = Game.new(Date.strptime(d))
    tokens.each do |l|
      tid, sc = l.split ":"
      t = team_id_to_team_map[tid]
      unless t
        puts "Could not find team with id: #{tid}"
      else
        g.add_team(t)
        g.set_score(t, sc.to_i)
      end
    end
    g
  end

  private
  def find_winner_loser()
    @winner = @loser = teams.first
    high_score = low_score = get_score(teams.first)
    @teams.each do |t|
      if(get_score(t)>high_score)
        high_score = get_score(t)
        @winner = t
      elsif(get_score(t)<low_score)
        low_score = get_score(t)
        @loser = t
      end
    end
  end
end