class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :categories, dependent: :destroy
  has_many :operations, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  validates :avatar, file_size: { less_than_or_equal_to: 1.megabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }
end
