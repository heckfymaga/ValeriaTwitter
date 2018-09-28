class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  validates :title, :summary, :body, presence: true
  belongs_to :category
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user

  def all_tags
    '#' + self.tags.map(&:name).join('#')
  end

  def all_tags=(names)
    self.tags = names[names.index('#').next..-1].split('#').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def self.search(search)
    ids = []
    search.split(' ').map do |word|
      Post.all.each do |post|
        if(post.title.downcase.include?(word.strip.downcase) or post.body.downcase.include?(word.strip.downcase) or post.summary.downcase.include?(word.strip.downcase))
          ids << post.id
        end
      end
    end
    Post.all.where(id: ids)
  end

end
