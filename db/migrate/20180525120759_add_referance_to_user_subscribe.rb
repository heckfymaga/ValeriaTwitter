class AddReferanceToUserSubscribe < ActiveRecord::Migration
  def change
    add_column :user_subscribes, :author_id, :integer
  end
end
