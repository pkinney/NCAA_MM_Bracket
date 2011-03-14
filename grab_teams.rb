#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ncaa_web_utils'

require 'team'
# http://stats.ncaa.org/team/inst_team_list/10440?division=1

#h = Net::HTTP.new('stats.ncaa.org', 80)
teams = {}
for s in 1..3
  puts "Division #{s}"
#  resp, data = h.get("/team/inst_team_list/10440?division=#{s}", nil )
  doc = Nokogiri::HTML(open("http://stats.ncaa.org/team/inst_team_list/10440?division=#{s}"))
  doc.css('a').each do |node|
    if(node.is_team_link?)
      team = Team.new(node.number_from_team_link, node.content)
      team.division=s
#      puts name, num
      puts "Error already exists but different [#{teams[team.id].name}] != #{team.name} (#{team.id})" if teams[team.id] && teams[team.id].name != team.name
      teams[team.id] ||= team
    end
  end
end

f = File.open(ARGV[0] || 'teams.txt', 'w')
teams.each_pair {|num, t| puts "#{num}|#{t.name}|#{t.division}"}
teams.each_pair {|num, t| f.write "#{num}|#{t.name}|#{t.division}\n"}
f.close

puts "#{teams.size} teams loaded."
