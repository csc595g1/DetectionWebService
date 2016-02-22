class Detection < ActiveRecord::Base
  belongs_to :smart_product
  has_and_belongs_to_many :users
  validates_presence_of :smart_product
end
