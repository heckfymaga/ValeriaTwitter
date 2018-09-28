class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  belongs_to :role
  has_many :posts
  has_many :responsibilities
  has_many :categories, through: :responsibilities
  has_many :user_subscribes
  has_many :category_subscribes

  def normal?
    self.role_id == Role::USER
  end
  def admin?
    self.role_id == Role::ADMIN
  end
  def head?
    self.role_id == Role::HEAD
  end
  def allowed?(post)
    ((post.user.id == self.id)) or
        ((self.admin?) and (self.categories.map(&:subtree_ids)).flatten.include?(post.category_id)) or
        (self.head?)
  end

  def user_subscribed?(user)
    UserSubscribe.all.where(user_id: self.id, author_id: user.id).any?
  end
  def category_subscribed?(category)
    CategorySubscribe.all.where(user_id: self.id, category_id: category.id).any?
  end

  def subscribed_categories
    Category.all.where(id: Category.all.where(id: CategorySubscribe.all.where(user_id: self.id).map(&:category_id).flatten).map(&:subtree_ids).flatten.uniq)

  end
  def subscribed_users
    User.all.where(id: UserSubscribe.all.where(user_id: self.id).map(&:author_id).flatten)
  end
  def subscribed_posts
    Post.all.where(id: (self.subscribed_categories.map(&:posts).map(&:ids).flatten + self.subscribed_users.map(&:posts).map(&:ids).flatten).uniq)
  end
end
