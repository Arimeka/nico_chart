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

class Video < ActiveRecord::Base
  # Validations
  # ======================================================
  validates :title, :nico_id, :uploaded_at, presence: true

  # Relations
  # ======================================================
  has_many :rankings, dependent: :destroy
end
