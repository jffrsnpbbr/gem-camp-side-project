class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = Item.includes(:categories).all
  end
end
