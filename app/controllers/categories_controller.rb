require 'utils/fetch_url'

class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_category, only: %i[edit update destroy]
  before_action :check_params, only: [:show]

  def index
    if user_signed_in?
      @categories = if params[:search].present?
                      current_user.categories.includes([icon_attachment: :blob])
                        .where('name ~* ? and name != ?', params[:search], 'personal_budget').order name: :asc
                    else
                      current_user.categories.includes([icon_attachment: :blob]).where('name != ?', 'personal_budget')
                        .order name: :asc
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

    unless params[:img].nil?
      req = FetchUrl.new(params[:img])

      if req.ok?
        @category.icon.attach(io: StringIO.new(req.response.read_body),
                              filename: "#{@category.name}_category.#{req.response.content_type.split('/')[1]}",
                              content_type: req.response.content_type)
      else
        @category.errors.add(:icon, :invalid, message: 'is invalid.')
        render :new, status: :unprocessable_entity
        return
      end
    end

    if @category.save(context: :category_creation)
      redirect_to categories_path, notice: 'Category created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    category = current_user.categories.find(params[:id])
    category.destroy

    redirect_to root_path, notice: 'Category deleted successfully.'
  end

  private

  def category_params
    params.require(:category).permit :name, :icon, :description
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def check_params
    params[:page] ||= '0'
    params[:page_items] ||= '5'
  end
end
