require 'sequel'

#$DB[:users] << {:user_id => 100000788524064, :full_name => "Daniel Lamando"}
#p $DB[:users].all

class DB
  def initialize
    @db = Sequel.postgres 'social-dump',
      :host => 'localhost',
      :user => 'social-dump',
      :password => 'DlDkp4Js'

    @db[:users, :pages, :posts, :groups, :comments, :likes, :targets].truncate

    @cache = {}
  end

  def find_or_create hash
    return @cache[hash['id']] if @cache.has_key? hash['id']

    if hash['category'] # page
      row = @db[:pages].where(:page_id => hash['id']).first
      row &&= row[:page_id]

      row ||= @db[:pages].insert(
        :page_id => hash['id'],
        :name => hash['name'],
        :description => hash['description'])

      row = ['page', row]
    elsif hash['version'] # group
      row = @db[:groups].where(:group_id => hash['id']).first
      row &&= row[:group_id]

      row ||= @db[:groups].insert(
        :group_id => hash['id'],
        :name => hash['name'],
        :owner_id => (find_or_create(hash['owner'])[1] rescue nil),
        :description => hash['description'])

      row = ['group', row]
    else # assume user
      row = @db[:users].where(:user_id => hash['id']).first
      row &&= row[:user_id]

      row ||= @db[:users].insert(
        :user_id => hash['id'],
        :name => hash['name'])

      row = ['user', row]
    end

    @cache[hash['id']] = row
  end

  def [] *tables
    @db[*tables]
  end
end
