require 'open-uri'
require 'json'

class Graph
  APP_ID = '221876217903089'
  APP_SECRET = 'c94a2afcf83cb35e6ff7ffaf1d612793'
  BASE = 'https://graph.facebook.com/'

  def initialize
    @token = open("#{BASE}oauth/access_token?client_id=#{APP_ID}&client_secret=#{APP_SECRET}&grant_type=client_credentials").read
  end

  def get! url
    p url
    JSON.parse open(url.sub('|', '%7C')).read
  end

  def get *paths
    get! resolve_path(paths)
  end
  def get_params path, params=nil
    get! resolve_path([path], params)
  end

  def resolve_path paths, params=nil
    params = params ? "#{params}&#{@token}" : @token
    "#{BASE}#{paths.join('/')}?#{params}"
  end


  def get_list *paths
    PaginatedList.new self, resolve_path(paths)
  end
end

class PaginatedList
  attr_reader :data

  def initialize graph, url
    @graph = graph

    json = graph.get! url
    @data = json['data']
    @prev = json['paging']['previous'] rescue nil
    @next = json['paging']['next'] rescue nil
  end

  def next!
    @next && PaginatedList.new(@graph, @next)
  end
  def prev!
    @prev && PaginatedList.new(@graph, @prev)
  end
end