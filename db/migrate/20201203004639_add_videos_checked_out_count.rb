class AddVideosCheckedOutCount < ActiveRecord::Migration[6.0]
  def change
    add_column :customers,:videos_checked_out_count,:integer
  end
end
