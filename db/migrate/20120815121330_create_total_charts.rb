class CreateTotalCharts < ActiveRecord::Migration
  def change
    create_table :total_charts do |t|
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
    add_index :total_charts, :nico_id, unique: true
  end
end
