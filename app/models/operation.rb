class Operation < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :user

  validates_associated :user
  validates :categories, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }
  validates :amount, numericality: true, presence: true,
                     format: { with: /\A[-+]?\d+(?:\.\d{0,2})?\z/, message: 'max two decimal positions' }
  validates :amount, comparison: { other_than: 0, message: 'must be greater than 0' }

  def invalidate_user_balance
    errors.add :base, :invalid, message: 'Insufficient balance'
  end

  def invalidate_negative_amount
    errors.add :amount, :invalid, message: 'must be greater than 0'
  end
end
