class OperationsController < ApplicationController
  def new
    @operation = Operation.new
    @current_category = Category.find(params[:category_id])
    @others_categories = Category.includes([icon_attachment: :blob]).where.not(id: params[:category_id])
  end

  def create
    parsed_params = operation_params
    parsed_params[:categories] = if parsed_params[:categories].empty?
                                   [Category.find(params[:category_id])]
                                 else
                                   Category.find(*JSON.parse(parsed_params[:categories]) << params[:category_id])
                                 end
    @operation = Operation.new(**parsed_params, user: current_user)

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
    params.require(:operation).permit :name, :amount, :categories
  end
end
