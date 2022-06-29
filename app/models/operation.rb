class Operation < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :user

  validates_associated :user
  validates :name, presence: true, length: { maximum: 50 }
  validates :amount, presence: true, comparison: { greater_than_or_equal_to: 0 }
end
