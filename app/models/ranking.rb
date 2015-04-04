# == Schema Information
#
# Table name: rankings # Ranks
#
#  id             :integer          not null, primary key      # Ranks
#  rank_type      :string           default("total"), not null # Rank type
#  views_count    :integer          default(0), not null       # Views count
#  comments_count :integer          default(0), not null       # Comments count
#  mylist_count   :integer          default(0), not null       # My List count
#  total_score    :integer          default(0), not null       # Total count
#  video_id       :integer          not null                   # Video relation
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Ranking < ActiveRecord::Base
  # Validations
  # ======================================================
  validates :rank_type, :views_count, :comments_count,
            :mylist_count, :total_score,
            :video_id, presence: true

  # Relations
  # ======================================================
  belongs_to :video

  # Class methods
  #===============================================================
  class << self
    def aggregate_rank(type)
      # Delete old ranking
      Ranking.where(rank_type: type).destroy_all

      url = "http://www.nicovideo.jp/ranking/fav/#{type}/vocaloid?rss=2.0"
      doc = Nokogiri::XML(open(url))

      doc.xpath('//item').each_with_index do |item, index|
        rank = index + 1
        nico_id = item.css('link').text.split('/').last
        video = Video.find_or_initialize_by(nico_id: nico_id)

        info = Nokogiri::HTML(item.css('description').text)
        views_count = info.css(".nico-info .nico-info-#{type}-view").text.gsub(',', '').to_i
        comments_count = info.css(".nico-info .nico-info-#{type}-res").text.gsub(',', '').to_i
        mylist_count = info.css(".nico-info .nico-info-#{type}-mylist").text.gsub(',', '').to_i
        total_score = info.css('.nico-info .nico-info-number').text.gsub(',', '').to_i

        if video.new_record?
          video.title = item.css('title').text.gsub("第#{rank}位：", '')
          video.uploaded_at = Time.parse(item.css('pubDate').text)
        end

        client = YouTubeIt::Client.new
        youtube = client.videos_by(query: video.title).videos.first
        nico_title_int = video.title.unpack('C*')

        if youtube
          youtube_title_int = youtube.title.unpack('C*')
          nico_dist = (nico_title_int - youtube_title_int).size
          youtb_dist = (youtube_title_int - nico_title_int).size

          if nico_dist < 10 && youtb_dist < 10
            video.youtube_id = youtube.video_id.split(':').last
          end
        end
        video.save

        video.rankings.create(rank_type: type, views_count: views_count, comments_count: comments_count, mylist_count: mylist_count, total_score: total_score)
      end
    end
  end
end
