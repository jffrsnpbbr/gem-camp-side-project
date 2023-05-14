class CreateBets < ActiveRecord::Migration[7.0]
  def change
    create_table :bets do |t|
      t.belongs_to :item, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :coins, default: 1
      t.integer :batch_count, null: false
      t.string :state, default: :betting
      t.string :serial_number, null: false
      t.timestamps
    end
  end
end
