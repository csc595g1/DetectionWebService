class Detection < ActiveRecord::Base
  belongs_to :smart_product
  validates_presence_of :smart_product
end
