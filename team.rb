class Team
  attr_accessor :team_id, :name, :games, :division

  def initialize(team_id, name)
    @team_id = team_id
    @name = name
    @games = []
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

  def to_s
    "#{name} (##{team_id})"
  end
end