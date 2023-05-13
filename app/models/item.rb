class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :image, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_bets, presence: true
  validates :status, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :start_at, presence: true

  enum status: { inactive: 0, active: 1 }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  mount_uploader :image, ImageUploader

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: %i[pending ended cancelled], to: :starting, guards: %i[quantity_positive? active? today_is_less_than_offline?], success: [:decrease_quantity, :increase_batch_count]
      transitions from: :paused, to: :starting, guards: %i[quantity_positive? active? today_is_less_than_offline?]
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: %i[starting paused], to: :cancelled, success: %i[decrease_batch_count increase_quantity]
    end
  end

  def increase_quantity
    increment! :quantity
  end

  def decrease_quantity
    decrement! :quantity
  end

  def increase_batch_count
    increment! :batch_count
  end

  def decrease_batch_count
    decrement! :batch_count
  end

  def quantity_positive?
    quantity.positive? if quantity.present?
  end

  def today_is_less_than_offline?
    DateTime.current < offline_at
  end

  def destroy
    update(deleted_at: Time.current)
  end
end
