class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.belongs_to :item
      t.belongs_to :bet
      t.belongs_to :user
      t.belongs_to :address_book
      t.belongs_to :admin
      t.integer :item_batch_count
      t.string :state, default: 'won'
      t.integer :price
      t.datetime :paid_at
      t.string :picture
      t.text :comment
      t.timestamps
    end
  end
end
