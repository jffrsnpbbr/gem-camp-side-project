class Admin::BetsController < ApplicationController
  def index
    @bets = Bet.includes(:user, :item).all
  end
end
