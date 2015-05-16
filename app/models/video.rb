# == Schema Information
#
# Table name: videos # Video
#
#  id          :integer          not null, primary key # Video
#  title       :string           default(""), not null # Video title
#  youtube_id  :string                                 # Id on YouTube
#  nico_id     :string           default(""), not null # Id on NicoVideo
#  uploaded_at :datetime         not null              # Upload date on NicoVideo
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'google/api_client'

class Video < ActiveRecord::Base
  # Validations
  # ======================================================
  validates :title, :nico_id, :uploaded_at, presence: true

  # Relations
  # ======================================================
  has_many :rankings, dependent: :destroy

  def find_video
    client = Google::APIClient.new(
      key: GOOGLE_API_CONFIG['secret_access_key'],
      authorization: nil,
      application_name: 'NicoChart',
      application_version: '2.0.0'
    )
    youtube = client.discovered_api('youtube', 'v3')

    search_response = client.execute!(
      api_method: youtube.search.list,
      parameters: {
        part: 'snippet',
        q: title,
        maxResults: 1
      }
    )

    search_result = search_response.data.items.first

    if search_result && search_result.id.kind == 'youtube#video'
      nico_title_int = title.unpack('C*')
      youtube_title_int = search_result.snippet.title.unpack('C*')
      nico_dist = (nico_title_int - youtube_title_int).size
      youtb_dist = (youtube_title_int - nico_title_int).size

      if nico_dist < 10 && youtb_dist < 10
        if youtube_id != search_result.id.video_id.split(':').last
          self.youtube_id = search_result.id.video_id.split(':').last
          self.save
        end
      end
    end
  end
end
