class User < ActiveRecord::Base

  has_and_belongs_to_many :smart_products
  has_and_belongs_to_many :detections
  has_many :mobile_devices, :dependent =>  :destroy

  validates_uniqueness_of :email_address



end
