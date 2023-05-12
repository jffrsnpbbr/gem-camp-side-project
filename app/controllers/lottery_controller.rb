class LotteryController < ApplicationController
  def index
    @items = Item.includes(:categories).all
    @items = @items.where(categories: { name: params[:category] }) if params[:category].present?
  end
end
