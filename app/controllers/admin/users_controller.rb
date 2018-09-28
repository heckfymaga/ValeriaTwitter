class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:destroy]
  before_action :head_admin_protect, only: [:destroy]
  def destroy

    @user.posts.each do |post|
      post.delete
    end
    @user.destroy
    redirect_to root_path, success: 'Пользователь заблокирован'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def head_admin_protect # Проверка для того, чтобы никто не смог удалить главного администратора, кроме другого главного администратора
    if current_user.id == @user.id
      redirect_to desk_head_user_path, danger: 'У вас недостаточно прав'
    end
  end
end