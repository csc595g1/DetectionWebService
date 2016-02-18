class User < ActiveRecord::Base

  has_many :devices
  has_many :detections, :through => :devices

  validates_presence_of :token
  validates_uniqueness_of :token

end
