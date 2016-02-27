class AddApplianceToSmartProductsTable < ActiveRecord::Migration
  def change
    add_column :smart_products, :appliance_name, :string
  end
end
