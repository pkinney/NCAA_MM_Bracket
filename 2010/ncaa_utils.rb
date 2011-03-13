def game2s(game, teams)
  "#{teams[game[:away_team]][:name]} @ #{teams[game[:home_team]][:name]}: #{game[:away_score]}-#{game[:home_score]}"
end

def team_in_game?(game, team)
  game[:away_team] == team || game[:home_team] == team
end

def games4team(games, team)
  games.select{|g| team_in_game?(g, team)}
end

def score4team(game, team)
  game[:away_team] == team ? game[:away_score] : game[:home_score]
end

def score4opp(game, team)
  game[:away_team] == team ? game[:home_score] : game[:away_score]
end

def opponent(game, team)
  game[:away_team] == team ? game[:home_team] : game[:away_team]
end

def win?(game, team)
  score4team(game, team) > score4opp(game, team)
end