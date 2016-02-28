class MobileDevice < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :gcm_token
  validates_uniqueness_of :gcm_token, :scope => :user
end
