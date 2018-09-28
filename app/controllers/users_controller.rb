class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  def show
    @posts = @user.posts.order(created_at: :desc)
    @categories = Category.all.order(:name)
  end

  def subscribe
    if current_user.user_subscribed?(@user)
      UserSubscribe.all.where(user_id: current_user.id, author_id: @user.id).first.delete
      redirect_to user_path(@user), success: 'Вы успешно отписались от пользователя'
    else
      UserSubscribe.create(user_id: current_user.id, author_id: @user.id)
      redirect_to user_path(@user), success: 'Вы успешно подписались на пользователя'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end