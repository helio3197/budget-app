class Operation < ApplicationRecord
  has_and_belongs_to_many :categories
  belongs_to :user

  validates_associated :user
  validates :categories, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :amount, comparison: { greater_than: 0 }
end
