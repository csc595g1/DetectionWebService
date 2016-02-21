class ChangeDevicesTableToSmartProduct < ActiveRecord::Migration
  def up
    rename_table :devices, :smart_products
  end

  def down
    rename_table :smart_products, :devices
  end
end
