class VideoReleaseDateToDate < ActiveRecord::Migration[6.0]
  def change
    remove_column :videos, :release_date
    add_column :videos, :release_date, :date
  end
end
