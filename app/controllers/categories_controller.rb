class CategoriesController < ApplicationController
  before_action :auhtenticate_user!, except: %i[index]

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
end
