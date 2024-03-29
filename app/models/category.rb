class Category < ApplicationRecord
  has_and_belongs_to_many :operations, dependent: :destroy
  has_one_attached :icon
  belongs_to :user

  validates_associated :user, :operations
  validates :name, presence: true, length: { maximum: 20 }
  validates :name, uniqueness: { case_sensitive: false }, on: :category_creation
  validates :description, length: { maximum: 300 }, on: :category_creation
  validates :icon, presence: true, on: :category_creation

  validates :icon, file_size: { less_than_or_equal_to: 1.megabytes },
                   file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }
end
