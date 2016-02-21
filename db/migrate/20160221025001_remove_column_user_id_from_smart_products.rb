class RemoveColumnUserIdFromSmartProducts < ActiveRecord::Migration
  def up
    remove_belongs_to :smart_products, :user, index: true, foreign_key: true
  end

  def down
    add_belongs_to :smart_products, :user, index: true, foreign_key: true
  end
end
