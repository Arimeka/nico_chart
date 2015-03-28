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

require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:video) { create(:video) }

  subject { video }

  context 'instance' do
    it { should respond_to(:title) }
    it { should respond_to(:youtube_id) }
    it { should respond_to(:nico_id) }
    it { should respond_to(:uploaded_at) }

    it { should respond_to(:rankings) }

    it { should be_valid }
  end

  context 'not valid' do
    it 'without title' do
      video.title = nil
      expect(video).to be_invalid
    end

    it 'without nico_id' do
      video.nico_id = nil
      expect(video).to be_invalid
    end

    it 'without uploaded_at' do
      video.uploaded_at = nil
      expect(video).to be_invalid
    end
  end

  it 'destroy rankings after destroy video' do
    ranking = create(:ranking, video: video)
    expect(video.rankings).to eq [ranking]

    video.destroy
    expect(Ranking.all).to eq []
  end
end
