class Post < ActiveRecord::Base
  belongs_to :category
  has_many :taggings
  has_many :tags, through: :taggings
end
