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
    @favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/weekly/vocaloid'))
    @views = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/view/weekly/vocaloid'))
    @comments = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/res/weekly/vocaloid'))
    @mylist = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/mylist/weekly/vocaloid'))

    prepare
    page_iteration(@favorites)
    page_iteration(@views)
    page_iteration(@comments)
    page_iteration(@mylist)
    delete_old
  end

  def self.page_iteration(page)
    client = YouTubeIt::Client.new
    transaction do      
      1.upto(100) do |x|        
        v = page.css("div#item#{ x } table tr td p strong span").text
        nico_id = page.css("div#item#{ x } table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]

        if v[/,/].nil?
          val = v.to_i
        else
          val = (v[/(\d+),(\d+)/, 1] + v[/(\d+),(\d+)/, 2]).to_i
        end

        ch = find_by_nico_id(nico_id)

        if ch.nil?
          title = page.css("div#item#{ x } table tr a.watch").first.text
          page.css("div#item#{ x } table tr td p span strong").text[/(\d+)\D+(\d+)\D+(\d+)\D+(\d+:\d+)/]
          date = $3 + '.' + $2 + '.' + $1 + ' ' + $4

          if client.videos_by(:query => title, :max_results => 1).videos == []
            youtube_id = "empty"
          else
            youtube_id = client.videos_by(:query => title, :max_results => 1).videos.first.unique_id
          end

          case page
          when @favorites
            create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: 0, mylist: 0, fav: val, title: title, upload_date: date )
          when @views
            create( nico_id: nico_id, youtube_id: youtube_id, view: val, comment: 0, mylist: 0, fav: 0, title: title, upload_date: date )
          when @comments
            create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: val, mylist: 0, fav: 0, title: title, upload_date: date )
          when @mylist
            create( nico_id: nico_id, youtube_id: youtube_id, view: 0, comment: 0, mylist: val, fav: 0, title: title, upload_date: date )
          end                     
          
        else
          case page
          when @favorites
             ch.update_attributes( fav: val )
          when @views
            ch.update_attributes( view: val )
          when @comments
            ch.update_attributes( comment: val )
          when @mylist
            ch.update_attributes( mylist: val )
          end
        end
      end
    end
  end

  def self.delete_old
    delete_all( view: 0, comment: 0, mylist: 0, fav: 0 )
  end

  def self.prepare
    update_all( view: 0, comment: 0, mylist: 0, fav: 0 )
  end
end
