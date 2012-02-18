require './graph'
require './db'

db = DB.new
graph = Graph.new

if !db[:targets].any?
  db[:targets] << {
    :target_id => 203464953023967,
    :target_type => graph.get_params('203464953023967', 'metadata=1')['type'],
    :created_at => Time.now
  }
end

db[:targets].each do |target|
  if target[:scanned_at] && target[:scanned_at] > (Time.now - (60 * 15)) # 15 minutes
    next # don't scan again yet
  end

  info = graph.get(target[:target_id])
  record = db.find_or_create info
  p record

  feed = graph.get_list(target[:target_id], 'feed')
  p feed.data[0]
end
