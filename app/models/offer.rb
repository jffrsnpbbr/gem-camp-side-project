class Offer < ApplicationRecord
  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }

  has_many :orders
end
