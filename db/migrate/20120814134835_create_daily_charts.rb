class CreateDailyCharts < ActiveRecord::Migration
  def change
    create_table :daily_charts do |t|
      t.string :nico_id
      t.string :youtube_id
      t.integer :view
      t.integer :comment
      t.integer :mylist
      t.integer :fav
      t.string :title
      t.string :upload_date

      t.timestamps
    end
    add_index :daily_charts, :nico_id, unique: true
  end
end
