#!/usr/bin/ruby
require "load_teams"
require "tourney_game"
require "tournament"

class TournamentBuilder
  def self.load_tourney_teams(filename, all_teams = nil)
    all_teams ||= load_teams_id_to_team_map
    tourney_teams = []
    f = File.open(filename).each do |line|
      t = all_teams.each_value.select{|ta| ta.name == line.strip}.first
      if t
        tourney_teams << t
      else
        puts "!!!!!!!!!!!!!!!!!!!!!!! - #{line}"
        exit
      end
    end
    f.close
    puts "#{tourney_teams.size} teams in this tournament"
    tourney_teams
  end

  def self.build_bracket(tourney_teams)
    root_round = []
    for i in 0...tourney_teams.size/2 do
      t = TourneyGame.new
      t.set_teams(tourney_teams[i*2], tourney_teams[i*2+1])
      t.name = "Round 1, Game #{i+1}"
      t.round = 1
      root_round << t
    end

    Tournament.from_first_round(root_round)
  end
end
