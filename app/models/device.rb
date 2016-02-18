class Device < ActiveRecord::Base

  has_many :detections
  belongs_to :user
  validates_uniqueness_of :serial_no

end
