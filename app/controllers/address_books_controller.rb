class AddressBooksController < ApplicationController


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
    @address_book.user = current_user

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
    params.require(:address_book).permit(:address_region_id,
                                         :address_province_id,
                                         :address_city_id,
                                         :address_barangay_id,
                                         :address_street,
                                         :phone_number,
                                         :genre,
                                         :remark,
                                         :is_default,
                                         :name)
  end
end