class AddVideosCheckedOutCountColumnToCutomerTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :rentals, :videos_checked_out
  end
end
