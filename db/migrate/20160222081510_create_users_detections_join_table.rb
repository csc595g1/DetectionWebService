class CreateUsersDetectionsJoinTable < ActiveRecord::Migration
  def change
    create_table :detections_users do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :detection, index: true, foreign_key: true
    end
    add_index(:detections_users, [:user_id, :detection_id], :unique => true)
  end
end
