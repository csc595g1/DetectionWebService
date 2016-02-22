class RenameUserSmartProductJoinTable < ActiveRecord::Migration
  def change
    rename_table :user_smart_products, :smart_products_users
  end
end
