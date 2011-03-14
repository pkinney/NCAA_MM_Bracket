class Nokogiri::XML::Node
  def is_team_link?
    name == 'a' && self['href'] =~ /\/team\/index\/10440\?org_id=\d+/
  end

  def number_from_child
    children.each do |a|
      if a.is_team_link?
        return a.number_from_team_link
      end
    end

    children.each do |a|
      num = a.number_from_child
      if(num!=nil)
        return num
      end
    end

    nil
  end

  def number_from_team_link
    if is_team_link?
      self['href'].scan(/org_id=\d+/)[0].split("=")[1]
    else
      nil
    end
  end

  def scan_children(pattern)
    tr = []
    children.each do |c|
      tr << c.content.scan(pattern)
      tr << c.scan_children(pattern)
    end
    tr.flatten
  end
end