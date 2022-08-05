class BudgetController < ApplicationController
  def index
  end

  def new_deposit
    render_new_transaction
  end

  def exec_deposit
    @operation = balance_operation 'Deposit'

    @operation.transaction do
      @operation.save!
      current_user.update! balance: current_user.balance + operation_params[:amount].to_f
    rescue ActiveRecord::RecordInvalid
      render :new_transaction, status: :unprocessable_entity and return
    end
    redirect_to my_budget_path, notice: 'Deposit successful!'
  end

  def new_withdraw
    render_new_transaction
  end

  def exec_withdraw
  end

  private

  def balance_operation(name)
    Operation.new(**operation_params, name:, categories: [current_user.categories.first], user: current_user)
  end

  def render_new_transaction
    @operation = Operation.new
    render 'new_transaction'
  end

  def operation_params
    params.require(:operation).permit(:amount, :description)
  end
end
