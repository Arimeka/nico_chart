# == Schema Information
#
# Table name: charts
#
#  id          :integer          not null, primary key
#  nico_id     :string(255)
#  youtube_id  :string(255)
#  view        :integer
#  comment     :integer
#  mylist      :integer
#  fav         :integer
#  title       :string(255)
#  upload_date :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Chart < ActiveRecord::Base
  attr_accessible :comment, :fav, :image, :mylist, :nico_id, :title, :upload_date, :view, :youtube_id

  def self.get
  	delete_all

    favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/weekly/vocaloid'))
    views = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/view/weekly/vocaloid'))
    comments = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/res/weekly/vocaloid'))
    mylist = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/mylist/weekly/vocaloid'))
    client = YouTubeIt::Client.new
    rank = []

     # Create table by views
    1.upto(100) do |x|
      title = views.css("div#item#{ x } table tr a.watch").first.text
      v = views.css("div#item#{ x } table tr td p strong span").text
      nico_id = views.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]
      views.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
      date = $3 + '.' + $2 + '.' + $1 + ' ' + $4

      if client.videos_by(:query => title, :max_results => 1).videos == []
        youtube_id = "empty"
      else
        youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id
      end

      if v[/,/].nil?
        view = v.to_i
      else
        view = (v[/(\d+),(\d+)/, 1] + v[/(\d+),(\d+)/, 2]).to_i
      end
  		rank.push( { nico_id: nico_id, youtube_id: youtube_id, view: view, comment: 0, mylist: 0, fav: 0, title: title, upload_date: date } )
    end

    rank.each do |x|
    	create( nico_id: x[:nico_id], youtube_id: x[:youtube_id], view: x[:view], comment: x[:comment], mylist: x[:mylist], fav: x[:fav], title: x[:title], upload_date: x[:upload_date] )
    end

    # Add information about favorites
    1.upto(100) do |x|      	
      f = favorites.css("div#item#{ x } table tr td p strong span").text
      nico_id = favorites.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]

      if f[/,/].nil?
        fav = f.to_i
      else
        fav = (f[/(\d+),(\d+)/, 1] + f[/(\d+),(\d+)/, 2]).to_i
      end

      ch = find_by_nico_id(nico_id)

      if ch.nil?
      	title = favorites.css("div#item#{ x } table tr a.watch").first.text
      	favorites.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
      	date = $3 + '.' + $2 + '.' + $1 + ' ' + $4

      	if client.videos_by(:query => title, :max_results => 1).videos == []
          youtube_id = "empty"
        else
          youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id
        end

        create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: 0, mylist: 0, fav: fav, title: title, upload_date: date )
      else
        ch.update_attributes(fav: fav)
      end
    end

    # Add information about comments
    1.upto(100) do |x|      	
      c = comments.css("div#item#{ x } table tr td p strong span").text
      nico_id = comments.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]

      if c[/,/].nil?
        com = c.to_i
      else
        com = (c[/(\d+),(\d+)/, 1] + c[/(\d+),(\d+)/, 2]).to_i
      end

      ch = find_by_nico_id(nico_id)

      if ch.nil?
      	title = comments.css("div#item#{ x } table tr a.watch").first.text
      	comments.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
      	date = $3 + '.' + $2 + '.' + $1 + ' ' + $4

      	if client.videos_by(:query => title, :max_results => 1).videos == []
          youtube_id = "empty"
        else
          youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id
        end

        create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: com, mylist: 0, fav: 0, title: title, upload_date: date )
      else
        ch.update_attributes(comment: com)
      end
    end

    # Add information about mylist
    1.upto(100) do |x|      	
      m = mylist.css("div#item#{ x } table tr td p strong span").text
      nico_id = mylist.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]

      if m[/,/].nil?
        my_list = m.to_i
      else
        my_list = (m[/(\d+),(\d+)/, 1] + m[/(\d+),(\d+)/, 2]).to_i
      end

      ch = find_by_nico_id(nico_id)

      if ch.nil?
      	title = mylist.css("div#item#{ x } table tr a.watch").first.text
      	mylist.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
      	date = $3 + '.' + $2 + '.' + $1 + ' ' + $4

      	if client.videos_by(:query => title, :max_results => 1).videos == []
          youtube_id = "empty"
        else
          youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id
        end

        create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: 0, mylist: my_list, fav: 0, title: title, upload_date: date )
      else
        ch.update_attributes(mylist: my_list)
      end
    end
  end
end
