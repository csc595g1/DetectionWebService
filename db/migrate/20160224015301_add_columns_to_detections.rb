class AddColumnsToDetections < ActiveRecord::Migration
  def change
    add_column :detections, :category, :string
    add_column :detections, :date_occurred, :string
  end
end
