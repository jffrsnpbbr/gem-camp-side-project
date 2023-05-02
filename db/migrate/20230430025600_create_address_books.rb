class CreateAddressBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :address_books do |t|
      t.belongs_to :user
      t.belongs_to :address_region
      t.belongs_to :address_province
      t.belongs_to :address_city
      t.belongs_to :address_barangay
      t.string :address_street
      t.integer :genre
      t.string :name
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.timestamps
    end
  end
end
