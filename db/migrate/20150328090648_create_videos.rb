class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos, comment: 'Video' do |t|
      t.string    :title,        null: false, default: '', comment: 'Video title'
      t.string    :youtube_id,                             comment: 'Id on YouTube'
      t.string    :nico_id,      null: false, default: '', comment: 'Id on NicoVideo'
      t.datetime  :uploaded_at,  null: false,              comment: 'Upload date on NicoVideo'

      t.timestamps null: false
    end
  end
end
