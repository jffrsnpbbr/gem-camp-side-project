class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.string :genre
      t.integer :status
      t.integer :amount, default: 0
      t.integer :coins, default: 0
      t.timestamps
    end
  end
end
