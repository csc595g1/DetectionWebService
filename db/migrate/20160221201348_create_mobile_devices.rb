class CreateMobileDevices < ActiveRecord::Migration
  def change
    create_table :mobile_devices do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :gcm_token

      t.timestamps null: false
    end
  end
end
