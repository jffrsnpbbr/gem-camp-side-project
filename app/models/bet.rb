class Bet < ApplicationRecord
  belongs_to :item
  belongs_to :user

  validates :user_id, presence: true
  validates :item_id, presence: true
  validate :user_enough_coin?, on: :create

  after_validation :set_serial_number, :deduct_user_coin

  scope :recent, -> { order(created_at: :desc) }

  include AASM

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :won do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lose
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, success: %i[refund_user_coin deduct_coin]
    end
  end

  def deduct_user_coin
    User.update(id: user.id, coins: user.coins - 1) if user.coins.positive?
  end

  def refund_user_coin
    User.update(id: user.id, coins: user.coins + 1) if coins.positive?
  end

  def deduct_coin
    decrement! :coins if coins.positive?
  end

  def item_batch_bet_count
    item.bets.where(batch_count:).count
  end

  def item_batch_bet_coin_total
    item.bets.where(batch_count:).sum(:coins)
  end

  # method validations

  def user_enough_coin?
    errors.add :user, 'user do not have enough coin to continue' unless user.coins.positive?
  end

  def set_serial_number
    timestamp = Time.current.strftime '%Y%m%d'
    number_count = format '%04d', (item_batch_bet_count + 1).to_s
    self.serial_number = "#{timestamp}-#{item.id}-#{batch_count}-#{number_count}"
  end
end
