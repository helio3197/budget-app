module BudgetHelper
  def unavailable_balance?
    current_user.balance <= 0
  end
end
