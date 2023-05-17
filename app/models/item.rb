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
  has_many :bets
  has_many :winners

  mount_uploader :image, ImageUploader

  scope :online, -> { where('offline_at >= :date and online_at <= :date', date: DateTime.current) }

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: %i[pending ended cancelled],
                  to: :starting,
                  guards: %i[quantity_positive? active? today_is_less_than_offline?],
                  success: %i[decrease_quantity increase_batch_count]
      transitions from: :paused, to: :starting, guards: %i[quantity_positive? active? today_is_less_than_offline?]
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :bets_equal_or_greater_than_minimum_bets?,
                  success: %i[select_winner record_winner]
    end

    event :cancel do
      transitions from: %i[starting paused], to: :cancelled,
                  success: %i[decrease_batch_count increase_quantity cancel_bets]
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

  def bets_equal_or_greater_than_minimum_bets?
    bets.where(state: :betting, batch_count:).size >= minimum_bets
  end

  def cancel_bets
    bets.each { |bet| bet.cancel! if bet.may_cancel? }
  end

  def destroy
    raise 'Cannot delete Item with bets' unless bets.count.zero?

    update(deleted_at: Time.current)
  end

  def select_winner
    item_bets = Bet.where(state: :betting, batch_count:)

    random = Random.new
    draw = random.rand(item_bets.size)
    @won_bet = item_bets[draw]

    return unless @won_bet.won!

    item_bets.each { |bet| bet.lose! unless bet.id == @won_bet.id }
  end

  def record_winner
    bet_id = @won_bet.id
    user_id = @won_bet.user_id
    address_book_id = AddressBook.find_by(user_id:, is_default: true).id
    winner = winners.build(bet_id:, user_id:, address_book_id:)
    return unless winner.valid?

    winner.save
  end
end
