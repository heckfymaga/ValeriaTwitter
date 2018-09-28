class PostsController < ApplicationController

  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @posts = Post.order(created_at: :desc).paginate(page: params[:page], per_page: 5) #метод для выведения всех постов
    if params[:search]
      @posts = Post.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 5)
    else
      @posts = Post.all.order('created_at DESC').paginate(page: params[:page], per_page: 5)
    end
  end
  def subscribes
    @posts = current_user.subscribed_posts.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
  end
  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params) #созд нов объект и передаем в него парам-ры
    @post.user = current_user # записал кто именно создал пост
    if @post.save
      redirect_to @post, success: 'Статья успешно сохранена'
    else
      render :new, danger: 'Статья не создана'
    end
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to @post
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params #метод для фильтрации передаваемых пар-в
    params.require(:post).permit(:title, :summary, :body, :category_id, :image, :all_tags) #в парам-х должен присутств пост с 3 полями
  end

  def check_user
    if !current_user.allowed?(@post)
      redirect_to root_path, alert: "У вас нет прав доступа"
    end
  end
end