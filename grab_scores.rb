require 'net/http'
require 'load_teams'

# http://web1.ncaa.org/ssLists/schrec.do?orgID=2&sport=MBB

games = []

teams = load_teams
h = Net::HTTP.new('web1.ncaa.org', 80)
total = teams.size
counter = 0
teams.each_pair do |num,name|
  resp, data = h.get("/ssLists/schrec.do?orgID=#{num}&sport=MBB", nil )
  data.each_line do |line|
    if line =~ /\<tr.*\d{1,}.*\d{4}\/\d{2}\/\d{2}.*\d{1,3}-\d{1,3}/
      # puts line
      opp_num = (line.scan /\d{1,}/)[0]
      score = (line.scan /\d{1,3}-\d{1,3}/)[0]
      date = (line.scan /\d{4}\/\d{2}\/\d{2}/)[0]
      home = (line =~ /HOME/)
      our_score, opp_score = score.split "-" 
      puts "! could not find opponent: #{num}" unless teams[num]
      # puts "vs. #{teams[opp_num]}: #{score}"
      game = {}
      game[:home_team] = home ? num : opp_num
      game[:away_team] = home ? opp_num : num
      game[:date] = date
      game[:home_score] = home ? our_score : opp_score
      game[:away_score] = home ? opp_score : our_score
      
      # puts game.collect {|a,b| "#{a} => #{b}"}.join " | "
      
      # m =  games.select{|a| a[:date]==game[:date]}.select{|a| a[:home_team] == game[:home_team] || a[:away_team] == game[:home_team]}
      #       unless m.empty?
      #         puts "repeat game => " + (game.collect {|a,b| "#{a} => #{b}"}.join " | ") + " and " + (m[0].collect {|a,b| "#{a} => #{b}"}.join " | ")
      #       end
      
      if games.select{|a| a[:date]==game[:date]}.select{|a| a[:home_team] == game[:home_team] || a[:away_team] == game[:home_team]}.empty?
        games << game 
        puts "#{game[:date]},#{game[:home_team]},#{game[:away_team]},#{game[:home_score]},#{game[:away_score]}"
      end
    end
  end
  counter += 1
  puts "! #{counter}/#{total} - #{games.size} games"
  # games.each {|game| puts "#{game[:date]},#{game[:home_team]},#{game[:away_team]},#{game[:home_score]},#{game[:away_score]}"}
  # puts "___________"
  # return
end

f = File.open('/games.txt', 'w')
games.each {|game| f.write "#{game[:date]},#{game[:home_team]},#{game[:away_team]},#{game[:home_score]},#{game[:away_score]}\n"}
f.close

# for s in "a".."z"
#   
#   data.each_line do |line|
#     if line =~ /\<option/
#       num = (line.scan /\d{1,}/)[0]
#       name = (line.scan /\>.+/)[0]
#       name = name[1..name.length]
#       
#       puts "Error alraedy exisits but different [#{teams[num]}] != #{name} (#{num})" if teams[num] && teams[num] != name
#       teams[num] ||= name
#       #puts "#{num} - #{name}"
#     end
#   end
# end
# 
# h = Net::HTTP.new('web1.ncaa.org', 80)
# resp, data = h.get("/ssLists/schrec.do?school=#{s}&sport=MBB", nil )
# 
# f = File.open('/games.txt', 'w')
# teams.each_pair {|num, name| puts "#{num}|#{name}"}
# teams.each_pair {|num, name| f.write "#{num}|#{name}"}
# f.close
