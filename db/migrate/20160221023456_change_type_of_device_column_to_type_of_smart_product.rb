class ChangeTypeOfDeviceColumnToTypeOfSmartProduct < ActiveRecord::Migration
  def change
    rename_column :smart_products, :type_of_device, :type_of_smart_product
  end
end
