class ChangeColumnTypeOnVideos < ActiveRecord::Migration[6.0]
  def change
    change_column :videos, :release_date, :string
  end
end
