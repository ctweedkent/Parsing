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

def insertMatches(matches, playerId)
  $coll.update({:id => playerId}, { '$set' => {:matches => matches} })
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

  # # Get all player ids
  # a.get('http://tango.matchanalysis.com/players.jsp?statset=0-0-0-1') do |player_page|

  #   player_page.links.each do |link|
  #     text = link.text.strip
  #     next unless text.length > 0
  #     tempId = link.href.split('?personid=')[1]
  #     if(tempId == nil)
  #       next
  #     end
  #     entry = {}
  #     entry['id'] = tempId.split('&statset=')[0]
  #     entry['name'] = link.text
  #     insertContact(entry)
  #   end

  # end

  #For each player get a list of match ids

  players = $coll.find({:matches => {'$exists' => 0}}).to_a

  n = 1

  players.each do |player| 

    player['id'] = player['id'].strip 

    if n > 10 then break end

    matches = Array.new()

    url = "http://tango.matchanalysis.com/player-match-list.jsp?personid=#{player['id']}&teamid=&statset=0-0-0-400"

    a.get(url) do |matches_page|

        matches_page.links.each do |link|
        text = link.text.strip
        address = link.href.strip
        
        next unless text == "details"
        
        matchid = address.split('matchid=')[1].split('&personid=')[0]
        
        matches.push(matchid)
        
        end
    
    end

    n += 1

    insertMatches(matches, player['id'])

  end

  # players = $coll.find().to_a

  # players.each do |player|
  #   puts player
  # end

end




