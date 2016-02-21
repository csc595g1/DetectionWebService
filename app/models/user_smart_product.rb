class UserSmartProduct < ActiveRecord::Base
  belongs_to :user
  belongs_to :smart_product
end
