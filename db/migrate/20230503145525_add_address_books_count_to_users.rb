class AddAddressBooksCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :address_books_count, :integer
  end
end
