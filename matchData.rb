# Parse EHL Alumni Email List

require 'mechanize'
require 'json'
require 'mongo'

include Mongo

db = MongoClient.new("localhost", 27017).db("match")

$coll = db.collection("players")

def insertContact entry
  if entry['name'] != '' && entry['id'] != '' && !alreadyInserted(entry)
    id = $coll.insert(entry)
    puts 'inserted'
  end
end

def alreadyInserted entry
  id = $coll.find('name' => entry['name'], 'id' => entry['id']).to_a
  if id.count > 0
    return true
  end
  return false
end

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

  a.get('http://tango.matchanalysis.com/match-player.jsp?matchid=126&personid=216&teamid=&statset=0-0-0-1') do |player_page|

    

  end

end


