class AddTotalDepositToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :total_deposit, :decimal, precision: 18, scale: 2, default: 0
  end
end
