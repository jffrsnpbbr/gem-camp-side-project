class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { client: 0, admin: 1 }

  validates :phone_number, phone: {
    possible: true,
    allow_blank: false,
    types: %i[voip mobile],
    countries: [:ph]
  }

  mount_uploader :image, ImageUploader

  belongs_to :parent, class_name: 'User', optional: true
  has_many :address_books
  has_many :users
end
