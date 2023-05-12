class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :image, presence: true

  enum status: { inactive: 0, active: 1 }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  mount_uploader :image, ImageUploader

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: %i[pending ended cancelled], to: :starting, guards: %i[quantity_positive? active?]
      transitions from: :paused, to: :starting, guards: %i[quantity_positive? active?]
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: %i[starting paused], to: :cancelled
    end
  end

  def decrease_quantity
    decrement! quantity
  end

  def increase_batch_count
    increment! batch_count
  end

  def can_start?
    quantity_positive? && today_is_less_than_offline? && active?
  end

  def quantity_positive?
    quantity.positive?
  end

  def today_is_less_than_offline?
    DateTime.current < offline_at
  end

  def destroy
    update(deleted_at: Time.current)
  end
end
