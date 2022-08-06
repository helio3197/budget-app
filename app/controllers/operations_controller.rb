class OperationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @operation = Operation.new
    @current_category = Category.find(params[:category_id])
    @others_categories = current_user.categories.includes([icon_attachment: :blob]).where.not(id: params[:category_id])
  end

  def create
    user = current_user
    parsed_params = operation_params
    parsed_params[:categories] = if parsed_params[:categories].nil? || parsed_params[:categories].empty?
                                   [Category.find(params[:category_id])]
                                 else
                                   Category.find(*JSON.parse(parsed_params[:categories]) << params[:category_id])
                                 end
    operation_amount = parsed_params[:amount].to_f
    @operation = Operation.new(**parsed_params, amount: -operation_amount, user:)

    @operation.transaction do
      @operation.save!
      raise ActiveRecord::RecordInvalid if amount_negative? operation_amount
    end

    redirect_to category_path(params[:category_id]), notice: 'Transaction created successfully.'
  rescue ActiveRecord::RecordInvalid
    @operation.invalidate_negative_amount if amount_negative? operation_amount
    @current_category = Category.find(params[:category_id])
    @others_categories = user.categories.includes([icon_attachment: :blob]).where
      .not(id: params[:category_id])
    render :new, status: :unprocessable_entity
  end

  private

  def operation_params
    params.require(:operation).permit :name, :amount, :categories, :description
  end
end
