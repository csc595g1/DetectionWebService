class ChangeColumnDeviceIdToSmartProductId < ActiveRecord::Migration
  def change
    rename_column :detections, :device_id, :smart_product_id
  end
end
