#!/usr/bin/ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'

# http://stats.ncaa.org/team/inst_team_list/10440?division=1

#h = Net::HTTP.new('stats.ncaa.org', 80)
teams = {}
for s in 1..3
  puts "Division #{s}"
#  resp, data = h.get("/team/inst_team_list/10440?division=#{s}", nil )
  doc = Nokogiri::HTML(open("http://stats.ncaa.org/team/inst_team_list/10440?division=#{s}"))
  doc.css('a').each do |node|
    if(node['href'] =~ /\/team\/index\/10440\?org_id=\d+/)
      num = node['href'].scan(/\d+/)[1]
      name = node.content
#      puts name, num
      puts "Error already exists but different [#{teams[num]}] != #{name} (#{num})" if teams[num] && teams[num] != name
      teams[num] ||= name
    end
  end
end

f = File.open(ARGV[0] || 'teams.txt', 'w')
teams.each_pair {|num, name| puts "#{num}|#{name}"}
teams.each_pair {|num, name| f.write "#{num}|#{name}\n"}
f.close

puts "#{teams.size} teams loaded."
