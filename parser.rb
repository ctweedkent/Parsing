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

  my_page.links.each do |link|
    text = link.text.strip
    next unless text.length > 0
    puts text
  end

end


