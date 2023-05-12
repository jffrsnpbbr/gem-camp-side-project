class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  enum status: { inactive: 0, active: 1 }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  mount_uploader :image, ImageUploader

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: %i[pending paused ended cancelled], to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: %i[starting paused], to: :cancel
    end
  end

  def destroy
    update(deleted_at: Time.current)
  end
end
