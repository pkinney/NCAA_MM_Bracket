require 'net/http'

# http://web1.ncaa.org/ssLists/schrec.do?school=a&sport=MBB

h = Net::HTTP.new('web1.ncaa.org', 80)
teams = {}
for s in "a".."z"
  resp, data = h.get("/ssLists/schrec.do?school=#{s}&sport=MBB", nil )
  data.each_line do |line|
    if line =~ /\<option/
      num = (line.scan /\d{1,}/)[0]
      name = (line.scan /\>.+/)[0]
      name = name[1..name.length]
      
      puts "Error alraedy exisits but different [#{teams[num]}] != #{name} (#{num})" if teams[num] && teams[num] != name
      teams[num] ||= name
      #puts "#{num} - #{name}"
    end
  end
  # puts "Code = #{resp.code}"
  #   puts "Message = #{resp.message}"
  #   resp.each {|key, val| printf "%-14s = %-40.40s\n", key, val }
  #   p data[0..55]
end

f = File.open('/teams.txt', 'w')
teams.each_pair {|num, name| puts "#{num}|#{name}"}
teams.each_pair {|num, name| f.write "#{num}|#{name}"}
f.close
