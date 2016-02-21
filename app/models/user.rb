class User < ActiveRecord::Base

  has_many :user_smart_products
  has_many :smart_products, :through => :user_smart_products
  has_many :detections, :through => :smart_products
  has_many :mobile_devices

  validates_uniqueness_of :email_address



end
