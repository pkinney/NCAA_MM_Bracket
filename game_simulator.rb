module GameSimulator
  def self.simulate_tournament(tourney, proc=nil, &block)
    simulate_game(tourney.final_game, proc || block)
  end
  
  def self.simulate_game(tourney_game, proc=nil, &block)
    proc ||= block
    tourney_game.team1 ||= tourney_game.game1.winner || simulate_game(tourney_game.game1, proc)
    tourney_game.team2 ||= tourney_game.game2.winner || simulate_game(tourney_game.game2, proc)

    tourney_game.set_result(proc.call(tourney_game.team1, tourney_game.team2))
    tourney_game.winner
  end
end