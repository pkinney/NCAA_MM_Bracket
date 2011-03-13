require 'load_games'
require 'ncaa_utils'

t = load_teams
teams = {}
t.each_pair{|num,name| teams[num] = {:num => num, :name => name, :wins => 0, :differential => 0, :games => []}}
puts teams['328']
games = load_games

games.each do |game|
  home = teams[game[:home_team]]
  away = teams[game[:away_team]]
  if home and away
    home[:games] << game if home
    away[:games] << game if away
    home[:wins] += 1 if game[:home_score] > game[:away_score]
    away[:wins] += 1 if game[:home_score] < game[:away_score]
    home[:differential] += game[:home_score] - game[:away_score]
    away[:differential] += game[:away_score] - game[:home_score]
  end
end

teams.each_value{|team| team[:win_percentage] = team[:wins]/(team[:games].size+0.000000001)}
teams.each_value{|team| team[:ave_diff] = team[:differential]/(team[:games].size+0.000000001)}

elig_teams = teams.values.select{|a| a[:games].size>10}
elig_teams.each do |team| 
  d = team[:differential]
  team[:games].each do |game|
    d += teams[opponent(game, team[:id])][:ave_diff]
  end
  team[:ave_diff_1] = d/team[:games].size
end

sorted = elig_teams.sort {|a,b| a[:ave_diff] <=> b[:ave_diff]}.reverse

#sorted.each_index{|i| puts "#{i}. #{sorted[i][:name]}: #{sorted[i][:ave_diff_1]}"}

round1 = []
f = File.open("/Users/mpkinney/ncaa2010/tourney_teams.txt")
while line = f.gets
  num1 = line.scan /\d{2,}/
  round1 << teams["#{num1}"] if teams["#{num1}"]
end
f.close

while round1.size > 1
  puts "-----------------------------------------"
  round2 = []
  for i in 0..(round1.size/2-1) do
    round2 << (round1[i*2][:ave_diff] > round1[i*2+1][:ave_diff] ? round1[i*2] : round1[i*2+1])
    puts "#{round1[i*2][:name]} vs. #{round1[i*2+1][:name]} => #{round2[i][:name]}"
  end
  round1 = round2
end