class AddRoleToUser < ActiveRecord::Migration
  def change
    add_reference :users, :role_id, index: true, foreign_key: true
  end
end
