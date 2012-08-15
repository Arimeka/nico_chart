# == Schema Information
#
# Table name: total_charts
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

class TotalChart < ActiveRecord::Base
  attr_accessible :comment, :fav, :mylist, :nico_id, :title, :upload_date, :view, :youtube_id
  extend GetChart

  def self.get
    @favorites = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/fav/total/vocaloid'))
    @views = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/view/total/vocaloid'))
    @comments = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/res/total/vocaloid'))
    @mylist = Nokogiri::HTML(open('http://www.nicovideo.jp/ranking/mylist/total/vocaloid'))

    transaction do
      self.prepare
      page_iteration(@favorites)
      page_iteration(@views)
      page_iteration(@comments)
      page_iteration(@mylist)
      delete_old
    end
  end
end
