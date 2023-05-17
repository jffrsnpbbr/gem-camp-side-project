class OffersController < ApplicationController
  def index
    @offer = Offer.where(genre: params[:genre], status: params[:status])
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @offer.update(offer_params)
    if @offer.update(offer_params)
      redirect_to admin_offers_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :status, :amount, :coin)
  end
end
