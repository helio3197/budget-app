class BudgetController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_expenses = current_user.operations.where
      .not(id: current_user.categories.joins(:categories_operations).where(name: 'personal_budget')
                 .pluck(:operation_id)).sum(:amount)
    @total_deposits = current_user.operations.where(name: 'Deposit').sum(:amount)
    @total_withdrawals = current_user.operations.where(name: 'Withdraw').sum(:amount)
    @categories_expenses = current_user.categories.where.not(name: 'personal_budget').map do |c|
      {
        name: c.name,
        total: c.operations.sum(:amount).to_f.abs
      }
    end
    @categories_expenses = order_chart_data @categories_expenses
  end

  def new_deposit
    render_new_transaction
  end

  def exec_deposit
    @user = current_user
    @operation = balance_operation 'Deposit'
    operation_amount = operation_params[:amount]

    @operation.transaction do
      @operation.save!
      @user.update! balance: @user.balance + operation_params[:amount].to_f
      raise ActiveRecord::RecordInvalid if amount_negative? operation_amount
    end
    redirect_to my_budget_path, notice: 'Deposit processed successfully!'
  rescue ActiveRecord::RecordInvalid
    current_user.balance = @user.balance_was
    @operation.invalidate_negative_amount if amount_negative? operation_amount
    render :new_transaction, status: :unprocessable_entity
  end

  def new_withdraw
    render_new_transaction
  end

  def exec_withdraw
    @user = current_user
    @operation = balance_operation 'Withdraw'
    operation_amount = operation_params[:amount].to_f

    @operation.transaction do
      @operation.save!
      raise ActiveRecord::RecordInvalid if operation_amount > @user.balance || amount_negative?(operation_amount)

      @user.update! balance: @user.balance - operation_amount
    end
    redirect_to my_budget_path, notice: 'Withdrawal processed successfully!'
  rescue ActiveRecord::RecordInvalid
    current_user.balance = @user.balance_was
    @operation.invalidate_user_balance if operation_amount > @user.balance
    @operation.invalidate_negative_amount if amount_negative? operation_amount
    render :new_transaction, status: :unprocessable_entity and return
  end

  private

  def balance_operation(name)
    o = Operation.new(**operation_params, name:, categories: [@user.categories.first], user: @user)
    o.amount = o.amount.to_f
    o.amount = -o.amount if name == 'Withdraw'
    o
  end

  def render_new_transaction
    @operation = Operation.new
    render 'new_transaction'
  end

  def operation_params
    params.require(:operation).permit(:amount, :description)
  end

  def order_chart_data(list)
    list = list.sort { |a, b| b[:total] <=> a[:total] }
    if list.length > 4
      list[3] = {
        name: 'Others',
        total: list[3..].reduce(0) { |total, item| total + item[:total] }.truncate(2)
      }
    end
    list.first 4
  end
end
