class OperationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @operation = current_user.operations.includes(categories: { icon_attachment: :blob }).find params[:id]
  end

  def new
    @operation = Operation.new
    @current_category = current_user.categories.find(params[:category_id])
    others_categories params[:category_id]
  end

  def create
    parsed_params = operation_params
    parsed_params[:categories] = parse_categories_param parsed_params[:categories], params[:category_id]
    operation_amount = parsed_params[:amount].to_f
    @operation = Operation.new(**parsed_params, amount: -operation_amount, user: current_user)

    @operation.transaction do
      @operation.save!
      if (operation_amount > current_user.balance) || amount_negative?(operation_amount)
        raise ActiveRecord::RecordInvalid
      end

      current_user.update! balance: current_user.balance - operation_amount
    end

    redirect_to category_path(params[:category_id]), notice: 'Transaction created successfully.'
  rescue ActiveRecord::RecordInvalid
    current_user.balance = current_user.balance_was
    @operation.invalidate_negative_amount if amount_negative?(operation_amount)
    @operation.invalidate_user_balance if operation_amount > current_user.balance
    @current_category = current_user.categories.find(params[:category_id])
    others_categories params[:category_id]
    render :new, status: :unprocessable_entity
  end

  def update
    operation_to_revert = Operation.find params[:id]

    if operation_to_revert.created_at < Time.now - 2.days
      error = 'Only operations less than 2 days old can be reversed.'
      raise ActiveRecord::RecordInvalid
    end

    reverted_operation = Operation.new user: current_user, name: "[Refunded]#{operation_to_revert.name}",
                                       amount: -operation_to_revert.amount, reverted: true,
                                       description: 'Transaction reverted by the user.',
                                       categories: operation_to_revert.categories

    Operation.transaction do
      operation_to_revert.update! reverted: true
      reverted_operation.save!
      current_user.update! balance: current_user.balance + -operation_to_revert.amount
    end

    redirect_to category_path(operation_params[:category_id]),
                notice: "Operation ##{operation_to_revert.id} successfully refunded."
  rescue ActiveRecord::RecordInvalid => e
    error ||= e.record.errors.to_json
    redirect_to category_path(operation_params[:category_id]), notice: "Something went wrong: #{error}"
  end

  private

  def operation_params
    params.require(:operation).permit :name, :amount, :categories, :description, :category_id, :reverted
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
