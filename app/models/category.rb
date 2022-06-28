class Category < ApplicationRecord
  has_and_belongs_to_many :operations

  has_one_attached :icon

  validates :icon, file_size: { less_than_or_equal_to: 1.megabytes },
                   file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }
end
