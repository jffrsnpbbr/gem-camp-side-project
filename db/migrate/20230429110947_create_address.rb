class CreateAddress < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.belongs_to :user
      t.integer :genre
      t.string :name
      t.string :street_address
      t.string :remark
      t.boolean :is_default
      t.integer :user_id
      t.integer :region_id
      t.integer :province_id
      t.integer :city_id
      t.timestamps
    end
  end
end
