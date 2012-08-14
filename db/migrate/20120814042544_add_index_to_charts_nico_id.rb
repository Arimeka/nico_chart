class AddIndexToChartsNicoId < ActiveRecord::Migration
  def change
  	add_index :charts, :nico_id, unique: true
  end
end
