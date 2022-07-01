class OperationsController < ApplicationController
  def new
    @operation = Operation.new
    @current_category = Category.find(params[:category_id])
    @others_categories = Category.includes([icon_attachment: :blob]).where.not(id: params[:category_id])
  end

  def create
    @operation = Operation.new(**operation_params, user: current_user)

    if @operation.save
      redirect_to category_path(params[:category_id]), notice: 'Transaction created successfully.'
    else
      @current_category = Category.find(params[:category_id])
      @others_categories = Category.includes([icon_attachment: :blob]).where.not(id: params[:category_id])
      render :new, status: :unprocessable_entity
    end
  end

  private

  def operation_params
    params.require(:operation).permit :name, :amount
  end
end
