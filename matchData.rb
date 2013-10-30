# Parse EHL Alumni Email List

require 'json'
require 'net/http'
require 'mongo'
require 'active_support/core_ext'

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

personId = 8209
matchId = 12588

# Get the xml page
# finalUrl = 'http://tango.matchanalysis.com/match-player-data.jsp?statset=0-0-0-400&matchid=' + matchId.to_s + '&personid=' + personId.to_s
finalUrl = 'http://tango.matchanalysis.com/match-player-data.jsp'
params = { :statset =>  '0-0-0-400', :matchid => '12588', :personid => 8209 }
url = URI.parse(finalUrl)
url.query = URI.encode_www_form( params )
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}

print res.body

# jsonPoss = Hash.from_xml(res.body).to_json

# row = jsonPoss['doc']['ROWSET']['ROW']

# row.each do |player|
#   puts player['value']
# end



