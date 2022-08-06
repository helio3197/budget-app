class OperationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @operation = Operation.new
    @current_category = Category.find(params[:category_id])
    others_categories params[:category_id]
  end

  def create
    parsed_params = operation_params
    parsed_params[:categories] = parse_categories_param parsed_params[:categories], params[:category_id]
    operation_amount = parsed_params[:amount].to_f
    @operation = Operation.new(**parsed_params, amount: -operation_amount, user: current_user)

    @operation.transaction do
      @operation.save!
      raise ActiveRecord::RecordInvalid if operation_amount > @user.balance || amount_negative?(operation_amount)
    end

    redirect_to category_path(params[:category_id]), notice: 'Transaction created successfully.'
  rescue ActiveRecord::RecordInvalid
    @operation.invalidate_negative_amount if amount_negative? operation_amount
    @operation.invalidate_user_balance if operation_amount > @user.balance
    @current_category = Category.find(params[:category_id])
    others_categories params[:category_id]
    render :new, status: :unprocessable_entity
  end

  private

  def operation_params
    params.require(:operation).permit :name, :amount, :categories, :description
  end

  def others_categories(current_cat)
    @others_categories = current_user.categories.includes([icon_attachment: :blob]).where.not(id: current_cat)
      .where.not(name: 'personal_budget')
  end

  def parse_categories_param(categories_param, current_cat)
    if categories_param.nil? || categories_param.empty?
      [Category.find(current_cat)]
    else
      Category.find(JSON.parse(categories_param) << current_cat)
    end
  end
end
