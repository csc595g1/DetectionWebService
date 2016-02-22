class AddIndexToUserSpJoinTable < ActiveRecord::Migration
  def change
    add_index(:smart_products_users, [:user_id, :smart_product_id], :unique => true)
  end
end
