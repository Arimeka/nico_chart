class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings, comment: 'Ranks' do |t|
      t.string  :rank_type,       null: false, default: 'total',  comment: 'Rank type'
      t.integer :views_count,     null: false, default: 0,        comment: 'Views count'
      t.integer :comments_count,  null: false, default: 0,        comment: 'Comments count'
      t.integer :mylist_count,    null: false, default: 0,        comment: 'My List count'
      t.integer :total_score,     null: false, default: 0,        comment: 'Total count'
      t.integer :video_id,        null: false,                    comment: 'Video relation'

      t.timestamps null: false
    end
  end
end
