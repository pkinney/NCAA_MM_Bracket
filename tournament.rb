include "team"
include "tourney_game"

class Tournament
  attr_accessor :all_games

  @all_games = []
  @root_games = []
end