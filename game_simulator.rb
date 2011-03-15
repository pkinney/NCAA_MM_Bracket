module GameSimulator
  def simulate_game(tourney_game)
    tourney_game.team1 ||= tourney_game.game1.winner || simulate_game(tourney_game.game1)[:winner]
    tourney_game.team2 ||= tourney_game.game2.winner || simulate_game(tourney_game.game2)[:winner]

    result = determine_result(tourney_game.team1, tourney_game.team2)
    tourney_game.set_result(result[:winner], result[:spread])
    result
  end
end