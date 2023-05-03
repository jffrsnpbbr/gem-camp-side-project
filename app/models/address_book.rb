class AddressBook < ApplicationRecord
  USER_ADDRESS_BOOKS_LIMIT = 5
  
  belongs_to :user
  belongs_to :user, counter_cache: true
  belongs_to :address_region, :class_name => 'Address::Region'
  belongs_to :address_province, :class_name => 'Address::Province'
  belongs_to :address_city, :class_name => 'Address::City'
  belongs_to :address_barangay, :class_name => 'Address::Barangay'

  validate :user_address_book_limit, on: :create
 
  enum genre: { home: 0, office: 1} 

  private

  def user_address_book_limit
    self.errors.add(:user, "Address book limit reached, can't add another address") unless self.user.address_books_count < USER_ADDRESS_BOOKS_LIMIT
  end
end
