class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  before_create :set_serial_number

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :paid, :cancelled

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid,
                  success: %i[increase_user_coins_unless_genre_deduct
                              decrease_user_coins_if_genre_deduct
                              increase_total_deposit_if_genre_deposit]
    end

    event :cancel do
      transitions from: %i[pending submitted paid], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :user_has_enough_coin?,
                  success: %i[unless_genre_deduct_decrease_user_coins
                              if_genre_deduct_increase_user_coins
                              decrease_total_deposit_if_genre_deposit]
    end
  end

  def set_serial_number
    timestamp = Time.current.strftime '%Y%m%d'
    number_count = format '%04d', (user.orders.count + 1).to_s
    self.serial_number = "#{timestamp}-#{Order.maximum(:id) + 1}-#{user_id}-#{number_count}"
  end

  def increase_total_deposit_if_genre_deposit
    User.update(user.id, total_deposit: user.total_deposit + 1)
  end

  def decrease_total_deposit_if_genre_deposit
    User.update(user.id, total_deposit: user.total_deposit - 1)
  end

  def increase_coins
    increment! coins
  end

  def decrease_coins
    decrement! coins
  end

  def user_has_enough_coin?
    user.coins.positive?
  end

  def decrease_user_coins
    User.update(user.id, user.coins - 1)
  end

  def increase_user_coins
    User.update(user.id, user.coins + 1)
  end

  def increase_user_coins_unless_genre_deduct
    increase_user_coins unless deduct?
  end

  def decrease_user_coins_if_genre_deduct
    decrease_user_coins if deduct?
  end

  def decrease_user_coins_unless_genre_deduct
    decrease_user_coins unless deduct?
  end

  def increase_user_coins_if_genre_deduct
    increase_user_coins if deduct?
  end
end
