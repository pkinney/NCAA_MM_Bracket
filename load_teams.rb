def load_teams
  teams = {}
  f = File.open("/Users/mpkinney/ncaa2010/teams.txt")
  while line = f.gets
    num, name = line.split '|'
    teams[num] = name.strip
    # puts "#{num} - #{name}"
  end
  teams
end