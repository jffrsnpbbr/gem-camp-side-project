class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :offer
      t.string :serial_number
      t.string :state
      t.integer :amount, default: 0
      t.integer :coins, default: 0
      t.text :remarks
      t.integer :genre

      t.timestamps
    end
  end
end
