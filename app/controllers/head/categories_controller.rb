class Head::CategoriesController < Head::HeadController
  before_action :set_category, only: [:edit, :update, :destroy ]
  def index
    @categories = Category.all
  end
  def destroy
    @category.posts.map(&:delete)
    @category.destroy
    redirect_to head_categories_path, success: 'Категория успешно удалена вместе со всеми постами'
  end
  def edit
    @categories = Category.where("id != #{@category.id}").order(:name)
  end

  def update
    if @category.update_attributes(category_params)
      redirect_to head_categories_path, success: 'Категория изменена'
    else
      render :edit, danger: 'Произошла ошибка'
    end
  end

  def new
    @category = Category.new
    @categories = Category.all.order(:name)
  end
  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to head_categories_path, success: 'Категория создана'
    else
      render :new, danger: 'Произошла ошибка'
    end
  end
  private

  def set_category
    @category = Category.find(params[:id])
  end
  def category_params #метод для фильтрации передаваемых пар-в
    params.require(:category).permit(:name, :parent_id, :users)
  end
end