class Category < ActiveRecord::Base
  has_many :responsibilities
  has_many :users, through: :responsibilities
  has_many :posts
  has_ancestry
end
