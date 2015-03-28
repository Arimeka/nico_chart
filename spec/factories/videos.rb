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

FactoryGirl.define do
  factory :video do
    title       { Faker::Lorem.word }
    youtube_id  { Faker::Lorem.word }
    nico_id     { Faker::Lorem.word }
    uploaded_at { Faker::Date.backward }
  end
end
