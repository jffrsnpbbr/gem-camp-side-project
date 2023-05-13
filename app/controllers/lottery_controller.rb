class LotteryController < ApplicationController
  def index
    @items = Item.includes(:categories).online.active.starting
    @items = @items.where(categories: { name: params[:category] }) if params[:category].present?
  end
end
