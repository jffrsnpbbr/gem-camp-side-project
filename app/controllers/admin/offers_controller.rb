class Admin::OffersController < ApplicationController
  before_action :set_offer, except: %i[index new create]

  def index
    @offers = if params[:search].blank?
                Offer.all
              else
                Offer.where('`name` LIKE :search OR
                             `amount` LIKE :search OR
                             `coins`LIKE :search', search: "%#{params[:search]}%")
              end
    @offers = @offers.where genre: params[:genre] if params[:genre].present?
    @offers = @offers.where status: params[:status] if params[:status].present?
    @statuses = Offer.statuses
    @genres = Offer.distinct.pluck :genre
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    @offer.update(offer_params)
    if @offer.save
      redirect_to admin_offers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @offer.destroy

    redirect_to admin_offers_path
  end

  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :status, :amount, :coins)
  end

  def set_offer
    @offer = Offer.find(params[:id])
  end
end
