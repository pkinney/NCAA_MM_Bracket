require 'load_teams'

def load_games(teams = nil, filename = "games.txt")
  games = []
  teams ||= load_teams_id_to_team_map
  f = File.open(filename).each do |line|
    games << Game.from_save_string(line.strip, teams)
  end
  f.close
  puts "#{games.size} games loaded for #{teams.size} teams."
  games
end