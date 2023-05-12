class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  enum status: { inactive: 0, active: 1 }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  mount_uploader :image, ImageUploader

  def destroy
    update(deleted_at: Time.current)
  end
end
