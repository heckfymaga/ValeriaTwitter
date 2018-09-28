class CreateCategorySubscribes < ActiveRecord::Migration
  def change
    create_table :category_subscribes do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
