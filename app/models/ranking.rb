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

require 'open-uri'
require 'google/api_client'

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
      url = "http://www.nicovideo.jp/ranking/fav/#{type}/vocaloid?rss=2.0"
      doc = Nokogiri::XML(open(url))

      client = Google::APIClient.new(
        key: GOOGLE_API_CONFIG['secret_access_key'],
        authorization: nil,
        application_name: 'NicoChart',
        application_version: '2.0.0'
      )
      youtube = client.discovered_api('youtube', 'v3')
      results = Array.new

      doc.xpath('//item').each_with_index do |item, index|
        rank = index + 1
        nico_id = item.css('link').text.split('/').last
        video = Video.find_or_initialize_by(nico_id: nico_id)

        info = Nokogiri::HTML(item.css('description').text)
        views_count = info.css(".nico-info .nico-info-#{type}-view").text.gsub(',', '').to_i
        comments_count = info.css(".nico-info .nico-info-#{type}-res").text.gsub(',', '').to_i
        mylist_count = info.css(".nico-info .nico-info-#{type}-mylist").text.gsub(',', '').to_i
        total_score = info.css('.nico-info .nico-info-number').text.gsub(',', '').to_i

        date = info.css('.nico-info .nico-info-date').text.split('年')
        year = date.shift
        date = date[0].to_s.split('月')
        month = date.shift
        date = date[0].to_s.split('日')
        day = date.shift
        date = date[0].to_s.strip
        hour, minute, second = date.split('：')
        date = Time.new(year, month, day, hour, minute, second, '+09:00')

        if video.new_record?
          video.title = item.css('title').text.gsub("第#{rank}位：", '')
          video.uploaded_at = date
        end

        sleep(2) if Thread.list.size > 5

        results << Thread.new do
          search_response = client.execute!(
            api_method: youtube.search.list,
            parameters: {
              part: 'snippet',
              q: video.title,
              maxResults: 1
            }
          )

          search_result = search_response.data.items.first

          if search_result && search_result.id.kind == 'youtube#video'
            nico_title_int = video.title.unpack('C*')
            youtube_title_int = search_result.snippet.title.unpack('C*')
            nico_dist = (nico_title_int - youtube_title_int).size
            youtb_dist = (youtube_title_int - nico_title_int).size

            if nico_dist < 10 && youtb_dist < 10
              video.youtube_id = search_result.id.video_id.split(':').last
            end
          end

          {video: video, ranking: {rank_type: type, views_count: views_count, comments_count: comments_count, mylist_count: mylist_count, total_score: total_score}}
        end
      end

      Ranking.transaction do
        # Delete old ranking
        Ranking.where(rank_type: type).destroy_all
        results.each do |result|
          video = result.value[:video]
          ranking = result.value[:ranking]

          video.save
          video.rankings.create(ranking)
        end
      end
    end
  end
end
