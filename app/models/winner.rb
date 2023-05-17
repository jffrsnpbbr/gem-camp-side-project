class Winner < ApplicationRecord
  belongs_to :item
  belongs_to :user
  belongs_to :bet
  belongs_to :address_book
  belongs_to :admin, class_name: 'User', optional: true

  include AASM

  aasm column: :state do
    state :won, initial: true
    state :claimed, :submitted, :paid, :shipped, :delivered, :shared, :published, :unpublished

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid
    end

    event :ship do
      transitions paid: :betting, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: :shared, to: :published
    end

    event :unpublish do
      transitions from: :published, to: :unpublished
    end
  end
end
