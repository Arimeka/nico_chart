# == Schema Information
#
# Table name: daily_charts
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

class DailyChart < ActiveRecord::Base
  extend GetChart
  attr_accessible :comment, :fav, :mylist, :nico_id, :title, :upload_date, :view, :youtube_id

  def self.get
    if @favorites == nil
      @favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/daily/vocaloid'))
    end
    @views = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/view/daily/vocaloid'))
    @comments = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/res/daily/vocaloid'))
    @mylist = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/mylist/daily/vocaloid'))

    #transaction do      
      prepare
      page_iteration(@favorites)
      page_iteration(@views)
      page_iteration(@comments)
      page_iteration(@mylist)
      delete_old            
    #end
    expire_self_all_cache
  end
  
  def self.check
    @favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/daily/vocaloid'))
    nico_id = @favorites.css("div#item1 table tr a.watch").first.attributes["href"].value[/\w{2}\d+/]
    v = @favorites.css("div#item1 table tr td p strong span").text
    val = v.split(',').join.to_i
    
    if find_by_nico_id(nico_id).fav != val      
      get
    end    
  end
end
