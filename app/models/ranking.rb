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
end
