require "team"
require "tourney_game"

class Tournament
  attr_accessor :all_games, :root_games, :final_game

  def initialize()
    @all_games = []
    @root_games = []
    @final_game = nil
  end

  def root_games=(roots)
    @root_games = roots
    expand_tourney
  end

  def Tournament.from_root_round(roots)
    t = Tournament.new()
    t.root_games = roots
    t
  end

  def simulate!(game = @final_game)
    return unless game
    simulate!(game.game1)
    simulate!(game.game2)

    game.team1 ||= game.game1.winner
    game.team2 ||= game.game2.winner

    # This is where the simulation would go
    game.winner = game.team1
  end

  def print_tourney(game = @final_game)
    if game.game1
      print_tourney(game.game1)
    else
      puts game.team1.name
    end

    puts "#{" "*10*game.round}|--------->#{game.winner || game.name}"

    if game.game2
      print_tourney(game.game2)
    else
      puts game.team2.name
    end
  end

  private
  def expand_tourney
    @root_games.each do |g|
      @all_games << g
      child = g.child
      while child != nil
        @final_game = child
        @all_games << child
        child = child.child
      end
    end
    @all_games.uniq!
  end
end