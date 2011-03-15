#!/usr/bin/ruby
require 'load_games'
require 'team_utils'
require 'tournament_builder'

teams = load_teams_id_to_team_map("teams.txt")
preseason_games = load_games(teams, "games.txt")
elig_teams = TournamentBuilder.load_tourney_teams("tourney_teams.txt", teams)

for i in 1..3
  puts i
  elig_teams.each {|t| t.set_stat("cdiff#{i}", t.cumulative_differential(i))}
end

sorted = elig_teams.sort {|a,b| b.get_stat("cdiff4") <=> a.get_stat("cdiff4")}
#sorted.each_index{|i| puts "#{i+1}. #{sorted[i].name}: #{sorted[i].get_stat("cdiff1")}, #{sorted[i].get_stat("cdiff5")}"}
sorted.each{|t| puts "#{t.name},#{t.get_stat('cdiff1')},#{t.get_stat('cdiff2')},#{t.get_stat('cdiff3')},#{t.get_stat('cdiff4')}"}