# Parse EHL Alumni Email List

require 'mechanize'
require 'json'

a = Mechanize.new 
a.user_agent_alias = 'Mac Safari'
a.agent.redirect_ok = :all, true
a.ssl_version = 'SSLv3'
a.verify_mode = OpenSSL::SSL::VERIFY_NONE

a.get('http://tango.matchanalysis.com/index.jsp') do |page|

  # Submit the login form
  my_page = page.form_with(:name => 'login') do |f|
    f.j_username  = 'egehrig'
    f.j_password  = 'look888'
  end.click_button

  matches = Array.new()

  a.get('/player-match-list.jsp?personid=17995&teamid=&statset=0-0-0-400') do |page|

    page.links.each do |link|
    text = link.text.strip
    address = link.href.strip
    
    next unless text == "details"
    
    matchid = address.split('matchid=')[1].split('&personid=')[0]
    
    matches.push(matchid)
    
    end   
  end

  matches.each do |match|
    puts match
  end

end




