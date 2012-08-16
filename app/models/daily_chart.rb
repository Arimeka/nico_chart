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
    @favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/daily/vocaloid'))
    @views = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/view/daily/vocaloid'))
    @comments = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/res/daily/vocaloid'))
    @mylist = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/mylist/daily/vocaloid'))

    transaction do
      expire_self_all_cache
      prepare
      page_iteration(@favorites)
      page_iteration(@views)
      page_iteration(@comments)
      page_iteration(@mylist)
      delete_old      
    end
  end
end
