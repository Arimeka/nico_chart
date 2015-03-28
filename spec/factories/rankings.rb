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

FactoryGirl.define do
  factory :ranking do
    rank_type { Faker::Lorem.word }
    views_count 1
    comments_count 1
    mylist_count 1
    total_score 1
    video_id 1
  end
end
