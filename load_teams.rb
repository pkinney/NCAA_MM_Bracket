require "team"

def load_teams_id_to_team_map(file = "teams.txt")
  teams = {}
  f = File.open(file)
  while line = f.gets
    team = Team.load(line)
    teams[team.team_id] = team
#    puts "#{num} - #{name}"
  end
  puts "#{teams.size} teams loaded"
  teams
end