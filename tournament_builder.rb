#!/usr/bin/ruby
require "load_teams"
require "tourney_game"
require "tournament"

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
    root_round = []
    for i in 0...tourney_teams.size/2 do
      t = TourneyGame.new
      t.set_teams(tourney_teams[i*2], tourney_teams[i*2+1])
      t.name = "Round 1, Game #{i+1}"
      t.round = 1
      root_round << t
    end

    last_round = root_round
    round = 2
    while last_round.size>1
      this_round = []
      for i in 0...last_round.size/2 do
        t = TourneyGame.new
        t.set_parents(last_round[i*2], last_round[i*2+1])
        t.round = round
        t.name = "Round #{round}, Game #{i+1}"
        this_round << t
      end
      round += 1
      last_round = this_round
    end

    Tournament.from_root_round(root_round)
  end
end

tt = TournamentBuilder.load_tourney_teams("tourney_teams.txt")
brak = TournamentBuilder.build_bracket(tt)
brak.print_tourney
brak.simulate!
brak.print_tourney
