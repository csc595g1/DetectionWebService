class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :serial_no
      t.string :type_of_device
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
