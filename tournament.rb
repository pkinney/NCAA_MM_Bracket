require "team"
require "tourney_game"

class Tournament
  attr_accessor :all_games, :first_round, :final_game

  def initialize()
    @all_games = []
    @first_round = []
    @final_game = nil
  end

  def first_round=(roots)
    @first_round << roots
    @first_round.flatten!
    @first_round.each { |rg| rg.round = 1  }
    create_tourney_tree if @first_round.any?{|g| g.child==nil}
    traverse_tourney
  end

  def Tournament.from_first_round(roots)
    t = Tournament.new()
    t.first_round = roots
    t
  end

  def Tournament.from_final_game(final)
    final
    round = [final]
    first = nil
    unless round.empty?
      next_round = []
      round.each do |g|
        next_round << g.game1 if g.game1
        next_round << g.game2 if g.game2
      end
      round = next_round
      if round
        first = round
      end
      puts round.size
    end
    from_first_round(first)
  end

#  def simulate!(simulator, game = @final_game)
#    return unless game
#    simulate!(game.game1)
#    simulate!(game.game2)
#
#    game.team1 ||= game.game1.winner
#    game.team2 ||= game.game2.winner
#
#    # This is where the simulation would go
#    game.winner = game.team1
#  end

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
  def traverse_tourney
    puts "Traversing Tourney..."
    count_rounds = 0
    @first_round.each do |g|
      @all_games << g
      child = g.child
      count_rounds = 1
      while child != nil
        @final_game = child
        @all_games << child
        child = child.child
        count_rounds += 1
      end
    end
    puts "Tournament traversed with #{count_rounds} rounds."
    @all_games.uniq!
  end

  def create_tourney_tree
    last_round = @first_round
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
  end
end