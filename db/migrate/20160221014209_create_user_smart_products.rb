class CreateUserSmartProducts < ActiveRecord::Migration
  def change
    create_table :user_smart_products do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :smart_product, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
