class LotteryController < ApplicationController
  before_action :set_item, only: %i[show bet]
  before_action :set_user_bets, only: :show
  before_action :set_bet_amount, only: :bet
  before_action :authenticate_user!, only: :bet

  def index
    @items = Item.includes(:categories).online.active.starting
    @items = @items.where(categories: { name: params[:category] }) if params[:category].present?
  end

  def show
    render :show, locals: { item: @item, current_user_bets: @current_user_bets }
  end

  def bet
    if @item.starting? && current_user.coins > @bet_amount
      @bet_amount.times do
        bet = Bet.new(user: current_user, item: @item, batch_count: @item.batch_count)
        bet.save if bet.valid?
      end
      redirect_to lottery_path(@item)
    else
      redirect_to lottery_path, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.includes(:bets).find(params[:id])
  end

  def set_user_bets
    @current_user_bets = @item.bets.where(user: current_user, batch_count: @item.batch_count) if user_signed_in?
  end

  def set_bet_amount
    @bet_amount = params[:bet_amount].to_i
  end
end
