class ChangeColumnRoleId < ActiveRecord::Migration
  def change
    change_column_default :users, :role_id, 1
  end
end
