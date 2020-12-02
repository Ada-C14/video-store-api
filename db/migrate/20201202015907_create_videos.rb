class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :overview
      t.datetime :release_date
      t.integer :total_inventory
      t.integer :available_inverntory

      t.timestamps
    end
  end
end
