class AddressBooksController < ApplicationController
  before_action :set_user
  before_action :set_address_book, except: [:index, :new]
  before_action :sanitize_params
  def index
    @address_books = AddressBook.includes(
      :user,
      :address_region,
      :address_province,
      :address_city,
      :address_barangay
    ).where(user: current_user)
  end
  def new
    @address_book = AddressBook.new
  end

  def create
    @address_book = AddressBook.new(address_book_params)
    @address_book.user_id = current_user.id
    if @address_book.save
      redirect_to address_books_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end
  def update
    if @address_book.update(address_book_params)
      redirect_to address_books_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def set_address_book
    @address_book = AddressBook.includes(
      :user,
      :address_region,
      :address_province,
      :address_city,
      :address_barangay
    ).find(params[:id])
  end

  def address_book_params
    puts params.require(:address_book)
    params.require(:address_book).permit(:address_region_id,
                                         :address_province_id,
                                         :address_city_id,
                                         :address_barangay_id,
                                         :street_address,
                                         :phone_number,
                                         :remark,
                                         :is_default,
                                         :name)
  end

  def sanitize_params
    params[:genre] = params[:genre].to_i
  end

end