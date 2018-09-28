class Head::UsersController < Head::HeadController
  before_action :find_user, only: [:set]
  before_action :admin_protect, only: [:set]
  def desk
    @admins = User.where(role_id: Role::ADMIN)
    @heads = User.where(role_id: Role::HEAD)
  end
  def set
    @user.role_id = params[:user][:role_id]
    if @user.save
      case @user.role_id
      when Role::HEAD
        redirect_to desk_head_user_path, success: 'Пользователь назначен главным администратором'
      when Role::ADMIN
        redirect_to desk_head_user_path, success: 'Пользователь назначен администратором'
      when Role::USER
        redirect_to desk_head_user_path, success: 'Пользователь уволен'
      end
    end
  end
  def assign
    @user = User.find(params[:id])
    @category = Category.find(params[:category][:category_id])
    if !@user.admin?
      redirect_to user_path(@user), danger: 'Пользователь не является администратором'
    elsif @user.categories.where(id: @category.descendant_ids).any?
      Responsibility.all.where(user_id: @user.id, category_id: @category.descendant_ids).each do |r|
        r.delete
      end
      Responsibility.create(user_id: @user.id, category_id: @category.id)
      redirect_to user_path(@user), success: 'Администратор назначен ответственным за эту должность'
    elsif @user.categories.where(id: @category.path_ids).any?
      redirect_to user_path(@user) , danger: 'Данный администратор уже назначен ответственным за данную категорию'
    else
      Responsibility.create(user_id: @user.id, category_id: @category.id)
      redirect_to user_path(@user), success: 'Администратор назначен ответственным за эту должность'
    end
  end
  def dismiss
    @user = User.find(params[:id])
    @category = Category.find(params[:category][:category_id])
    if !@user.admin?
      redirect_to user_path(@user), danger: 'Пользователь не является администратором'
    elsif @user.categories.where(id: @category.id).empty?
      redirect_to user_path(@user), danger: 'Данный администратор не назначен ответственным за данную категорию'
    else
      Responsibility.all.where(category_id: @category.id, user_id: @user.id).first.delete
      redirect_to user_path(@user), success: 'Администратор отстранен от данной категории'
    end
  end

  private

  def find_user
    if User.where(id: params[:user_id]).exists?
      @user = User.find(params[:user_id])
    else
      redirect_to desk_head_user_path, danger: 'Пользователь с таким номером не найден'
    end
  end

  def admin_protect
    if @user.id == current_user.id
      redirect_to desk_head_user_path, danger: 'У вас нет возможности выполнить данное действие'
    end
  end

end