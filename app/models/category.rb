class Category < ApplicationRecord
  has_and_belongs_to_many :operations
  has_one_attached :icon
  belongs_to :user

  validates_associated :user, :operations
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :icon, presence: true

  validates :icon, file_size: { less_than_or_equal_to: 1.megabytes },
                   file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }
end
