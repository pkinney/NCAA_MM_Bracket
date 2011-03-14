#!/usr/bin/ruby
require "load_teams"
require "tourney_game"

class TournamentBuilder
  def self.load_tourney_teams(filename, all_teams = nil)
    all_teams ||= load_teams
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
    this_round = root_round = []
    s = tourney_teams.size/2
    puts s
    for i in 0...s do
      puts i
      t = TourneyGame.new
      t.set_teams(tourney_teams[i*2], tourney_teams[i*2+1])
      this_round << t
      puts t
    end
  end
end

tt = TournamentBuilder.load_tourney_teams("tourney_teams.txt")
TournamentBuilder.build_bracket(tt)