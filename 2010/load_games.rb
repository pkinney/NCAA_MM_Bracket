require 'load_teams'

def load_games
  games = []
  teams = load_teams
  f = File.open("/Users/mpkinney/ncaa2010/games.txt").each do |line|
    data = line.strip.split ","
    game = {:date => data[0], :home_team => data[1], :away_team => data[2], :home_score => data[3].to_i, :away_score => data[4].to_i}
    # puts "#{teams[game[:away_team]]} @ #{teams[game[:home_team]]}: #{game[:away_score]}-#{game[:home_score]}"
    games << game
  end
  f.close
  games
end