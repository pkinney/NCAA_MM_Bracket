#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

require 'ncaa_web_utils'
require 'load_teams'
require 'team'
require 'game'

# http://stats.ncaa.org/team/index/10440?org_id=721

games = []

teams = load_teams_id_to_team_map
total = teams.size
counter = 0
teams.values.each do |team|
  doc = Nokogiri::HTML(open("http://stats.ncaa.org/team/index/10440?org_id=#{team.team_id}"))
  puts "loaded http://stats.ncaa.org/team/index/10440?org_id=#{team.team_id}"
  game_rows = doc.css("tr").select{|tr| tr.children.select{|a| a.name == "td"}.any?{|td| td.children.any?{ |c| c.is_team_link?}}}
  game_rows.each do |tr|
    date_s = tr.scan_children(/\d{2}\/\d{2}\/\d{4}/).uniq[0]
    date = Date.strptime(date_s, "%m/%d/%Y")
    opp = teams[tr.number_from_child]
    score =  tr.scan_children(/\d{1,3} *- *\d{1,3}/).uniq[0]
    team_score, opp_score = score.split(/ *- */).collect{|s| s.to_i} if score
    if date && opp && team_score && opp_score
      game = Game.new(date, team, opp, team_score, opp_score)

      if (! games.any? {|a| a==game})
        games << game
        puts game
      end
    end
  end
  counter += 1
  puts "! #{counter}/#{total} - #{games.size} games"
end

f = File.open('games.txt', 'w')
games.each {|game| f.write "#{game.to_save_string}\n"}
f.close