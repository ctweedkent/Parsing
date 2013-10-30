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
    f.field_with(:id => "j_username").value = 'egehrig'
    f.field_with(:id => "j_password").value = 'look888'
  end.submit

  form = my_page.forms.first

  final = form.submit

  a.get('http://tango.matchanalysis.com/players.jsp?statset=0-0-0-400') do |page|

    # all = page.search("//table/tbody/tr/td")

    # if(all.first != nil)
    #   all = all.first.inner_html.split('<br>')
    # else
    #   break
    # end

    # puts "name is: "+all[2]+"\n"
    
    # entry['name'] = all[2]

    # all.each do |email| 

    #   if email.index('@') && email != 'nomail@ehl.ch'
    #     insertContact email, entry
    #     break
    #   end

    # end

  end

end


