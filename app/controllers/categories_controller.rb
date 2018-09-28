class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :subscribe]
  def show
    @posts = Post.all.where(category_id: Category.find(params[:id]).subtree_ids).order(created_at: :desc).paginate(page: params[:page], per_page: 5) #метод для выведения всех постов
  end

  def subscribe
    @user = current_user
    if @user.category_subscribed?(@category)
      CategorySubscribe.all.where(category_id: @category.id, user_id: @user.id).first.delete
      redirect_to category_path(@category), success: 'Вы успешно отписались от категории'
    else
      CategorySubscribe.create(category_id: @category.id, user_id: @user.id )
      redirect_to category_path(@category), success: 'Вы успешно подписались на категорию'
    end
  end
  private

  def set_category
    @category = Category.find(params[:id])
  end
end