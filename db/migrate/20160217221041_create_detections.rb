class CreateDetections < ActiveRecord::Migration
  def change
    create_table :detections do |t|
      t.string :notification
      t.timestamps :date_occured
      t.integer :duration_in_seconds
      t.belongs_to :device, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
