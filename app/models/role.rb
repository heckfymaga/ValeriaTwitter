class Role < ActiveRecord::Base
  has_many :users
  USER = 1
  HEAD = 2
  ADMIN = 3
end
