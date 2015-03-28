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

require 'rails_helper'

RSpec.describe Ranking, type: :model do
  let(:ranking) { create(:ranking) }

  subject { ranking }

  context 'instance' do
    it { should respond_to(:rank_type) }
    it { should respond_to(:views_count) }
    it { should respond_to(:mylist_count) }
    it { should respond_to(:total_score) }

    it { should respond_to(:video) }

    it { should be_valid }
  end

  context 'not valid' do
    it 'without rank_type' do
      ranking.rank_type = nil
      expect(ranking).to be_invalid
    end

    it 'without views_count' do
      ranking.views_count = nil
      expect(ranking).to be_invalid
    end

    it 'without comments_count' do
      ranking.comments_count = nil
      expect(ranking).to be_invalid
    end

    it 'without mylist_count' do
      ranking.mylist_count = nil
      expect(ranking).to be_invalid
    end

    it 'without total_score' do
      ranking.total_score = nil
      expect(ranking).to be_invalid
    end

    it 'without video_id' do
      ranking.video_id = nil
      expect(ranking).to be_invalid
    end
  end
end
