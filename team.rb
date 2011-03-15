class Team
  attr_accessor :team_id, :name, :games, :division

  def initialize(team_id, name)
    @team_id = team_id
    @name = name
    @games = []
    @stats = {}
  end

  def Team.load(line)
    s = line.split('|')
    team = Team.new(s[0], s[1])
    if(s.size==3)
      team.division = s[2]
    end
    team
  end

  def add_game(game)
    unless @games.any? {|g| g==game}
      @games << game
    end
  end

  def set_stat(stat_name, value)
    @stats[stat_name] = value
  end

  def get_stat(stat_name)
    @stats[stat_name]
  end

  def to_s
    "#{name} (##{team_id})"
  end
end