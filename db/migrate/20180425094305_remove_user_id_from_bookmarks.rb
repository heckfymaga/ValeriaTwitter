class RemoveUserIdFromBookmarks < ActiveRecord::Migration
  def change
    remove_column :bookmarks, :user_id, :integer
    remove_column :posts, :user_id, :integer
  end
end
