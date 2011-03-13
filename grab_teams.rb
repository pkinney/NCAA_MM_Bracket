require 'net/http'

# http://stats.ncaa.org/team/inst_team_list/10440?division=1

h = Net::HTTP.new('stats.ncaa.org', 80)
teams = {}
for s in 1..3
  puts "Division #{s}"
  resp, data = h.get("/team/inst_team_list/10440?division=#{s}", nil )
  data.each_line do |line|
    if line =~ /<a href="\/team\/index\/10440\?org_id=\d+/
      num = (line.scan /\d{1,}/)[1]
      name = (line.scan />.+</)[0]
      name = name[1..name.length-2]

      puts "Error already exists but different [#{teams[num]}] != #{name} (#{num})" if teams[num] && teams[num] != name
      teams[num] ||= name
    end
  end
end

f = File.open(ARGV[0] || 'teams.txt', 'w')
teams.each_pair {|num, name| puts "#{num}|#{name}"}
teams.each_pair {|num, name| f.write "#{num}|#{name}"}
f.close
