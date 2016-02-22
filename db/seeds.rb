# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

email1 = "test1@test.com"
email2 = "test2@test.com"
email3 = "test3@test.com"

user1 = User.find_by_email_address(email1)
user1 ||= User.create(:email_address => email1)

user2 = User.find_by_email_address(email2)
user2 ||= User.create(:email_address => email2)

user3 = User.find_by_email_address(email3)
user3 ||= User.create(:email_address => email3)

users =  [user1, user2, user3]

smart_product1 = SmartProduct.find_by_serial_no('d00001')
smart_product1 ||= SmartProduct.create(:serial_no => 'd00001', :type_of_smart_product => 'water')

smart_product2 = SmartProduct.find_by_serial_no('d00002')
smart_product2 ||= SmartProduct.create(:serial_no => 'd00002', :type_of_smart_product => 'fire')

user3 = User.find_by_email_address("test3@test.com")
gcm_token = 'fqOjTU5kMI4:APA91bFY86V89bj7pw1NEczAvTJ2CtaBzsrBo1auHrHDtkkwzquk0ftvakB41lW0sx60U4giE4NjlV6aQxeSG-IzUlbsm9YfKPZlqmn5szJ6_cFkX9ItxWEQMhG4mKTIcdICTcOFZvJB'

mobile_device = MobileDevice.find_by_gcm_token(gcm_token)
mobile_device ||= MobileDevice.create(:gcm_token => gcm_token, :user => user3)


users.each do | user |
  user.smart_products << smart_product1 if !user.smart_products.include? smart_product1
  user.smart_products << smart_product2 if !user.smart_products.include? smart_product2
  user.save
end

detection1 = Detection.create(:notification => "Water Leak", :smart_product => smart_product1, :duration_in_seconds => 30)
detection2 = Detection.create(:notification => "Fire sensed", :smart_product => smart_product2, :duration_in_seconds => 10)
