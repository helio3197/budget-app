class BudgetController < ApplicationController
  def index
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
end
