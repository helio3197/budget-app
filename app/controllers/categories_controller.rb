class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_category, only: %i[edit update destroy]
  before_action :check_params, only: [:show]

  def index
    if user_signed_in?
      @categories = if params[:search].present?
                      current_user.categories.includes([icon_attachment: :blob])
                        .where('name ~* ? and name != ?', params[:search], 'personal_budget').order created_at: :desc
                    else
                      current_user.categories.includes([icon_attachment: :blob]).where('name != ?', 'personal_budget')
                        .order created_at: :desc
                    end
    else
      render :home
    end
  end

  def show
    @category = current_user.categories.find(params[:id])
    @operations_length = @category.operations.length
    @category_operations = @category.operations.order(created_at: :desc).limit(params[:page_items].to_i)
      .offset(params[:page].to_i * params[:page_items].to_i)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(**category_params, user: current_user)

    if @category.save(context: :category_creation)
      redirect_to categories_path, notice: 'Category created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :icon
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def check_params
    params[:page] ||= '0'
    params[:page_items] ||= '5'
  end
end
