class Item < ApplicationRecord
  include AASM

  default_scope { where(deleted_at: nil )}

  enum status: { inactive: 0, active: 1 }
  
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting,:paused], to: :cancel
    end
  end
  
  def destroy
    update(deleted_at: Time.current)
  end
end
