class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    if user_signed_in?
      @categories = current_user.categories
    else
      render :home
    end
  end

  def new
    @category = Category.new
  end

  def create
    # @category = current_user.categories.new(category_params)
    @category = Category.new(**category_params, user: current_user)

    if @category.save
      redirect_to categories_path, notice: 'Category created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :icon
  end
end
