class Admin::WinnersController < ApplicationController
  before_action :set_winner, except: :index
  def index
    @winners = if params[:search].blank?
                Winner.includes(:item, :bet, :user, :address_book, :admin).all
              else
                Winner.joins(:user, :bet, :item).where('`serial_number` LIKE :search OR `email` LIKE :search')
              end
    @winners = @winner.find_by(state: params[:state]) if params[:state].present?
    @winners = @winner.where('`created_at` >= ?', params[:start_date]) if params[:start_date].present?
    @winners = @winner.where('`created_at` <= ?', params[:end_date]) if params[:end_date].present?
  end

  def state_submit
    return unless @winner.may_submit?

    redirect_to admin_winners_path if @winner.submit!
  end

  def state_pay
    return unless @winner.may_pay?

    redirect_to admin_winners_path if @winner.pay!
  end

  def state_ship
    return unless @winner.may_ship?

    redirect_to admin_winners_path if @winner.ship!
  end

  def state_deliver
    return unless @winner.may_deliver?

    redirect_to admin_winners_path if @winner.deliver!
  end

  def state_share
    return unless @winner.may_share?

    redirect_to admin_winners_path if @winner.share!
  end

  def state_publish
    return unless @winner.may_publish?

    redirect_to admin_winners_path if @winner.publish!
  end

  def state_unpublish
    return unless @winner.may_unpublish?

    redirect_to admin_winners_path if @winner.unpublish!
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end
