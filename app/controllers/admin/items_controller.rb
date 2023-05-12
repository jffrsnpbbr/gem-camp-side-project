class Admin::ItemsController < ApplicationController
  before_action :set_item, except: %i[index new create]

  def index
    @items = Item.includes(:categories).all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to admin_items_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to admin_items_path
  end

  def state_start
    @item.start! if @item.may_start?

    redirect_to admin_items_path
  end

  def state_pause
    return unless @item.may_pause?

    @item.pause!
    redirect_to admin_items_path
  end

  def state_end
    return unless @item.may_end?

    @item.end!
    redirect_to admin_items_path
  end

  def state_cancel
    return unless @item.may_cancel?

    @item.cancel!
    redirect_to admin_items_path
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :state, :online_at, :offline_at, :start_at,
                                 category_ids: [])
  end

  def set_item
    @item = Item.find(params[:id])
  end
end

t.string 'state'
t.integer 'batch_count'
t.datetime 'online_at'
t.datetime 'offline_at'
t.datetime 'start_at'
