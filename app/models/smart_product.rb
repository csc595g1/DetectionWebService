class SmartProduct < ActiveRecord::Base


  has_many :user_smart_products
  has_many :detections
  has_many :users, through: :user_smart_products

  validates_uniqueness_of :serial_no
  validates_presence_of :serial_no, :type_of_smart_product

end
