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
  extend GetChart
  
  def self.get

    @favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/weekly/vocaloid'))
    @views = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/view/weekly/vocaloid'))
    @comments = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/res/weekly/vocaloid'))
    @mylist = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/mylist/weekly/vocaloid'))

    transaction do      
      prepare
      page_iteration(@favorites)
      page_iteration(@views)
      page_iteration(@comments)
      page_iteration(@mylist)
      delete_old      
    end
    expire_self_all_cache
  end
end
