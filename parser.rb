# Parse EHL Alumni Email List

require 'mechanize'
require 'json'

a = Mechanize.new 
a.user_agent_alias = 'Mac Safari'
a.agent.redirect_ok = :all, true
a.ssl_version = 'SSLv3'
a.verify_mode = OpenSSL::SSL::VERIFY_NONE

a.get('http://tango.matchanalysis.com/') do |page|

  # Submit the login form
  my_page = page.form_with(:name => 'Form1') do |f|
    f.field_with(:id => "tbLogin").value = 'manuelaberger@mac.com'
    f.field_with(:id => "tbPassword").value = 'orchid123'
  end.submit

  form = my_page.forms.first

  final = form.submit

end


