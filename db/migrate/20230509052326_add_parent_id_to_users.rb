class AddParentIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :parent, index: true
  end
end
