# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
SmartProduct.destroy_all
Detection.destroy_all

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

water_sensor = SmartProduct.find_by_serial_no('X000LP8W23')
water_sensor ||= SmartProduct.create(:serial_no => 'X000LP8W23', :type_of_smart_product => 'water', :appliance_name => 'Sump Pump')

fire_sensor = SmartProduct.find_by_serial_no('X000QCX44H')
fire_sensor ||= SmartProduct.create(:serial_no => 'X000QCX44H', :type_of_smart_product => 'fire', :appliance_name => 'Living Room')

user3 = User.find_by_email_address("test3@test.com")
gcm_token = 'fqOjTU5kMI4:APA91bFY86V89bj7pw1NEczAvTJ2CtaBzsrBo1auHrHDtkkwzquk0ftvakB41lW0sx60U4giE4NjlV6aQxeSG-IzUlbsm9YfKPZlqmn5szJ6_cFkX9ItxWEQMhG4mKTIcdICTcOFZvJB'

mobile_device = MobileDevice.find_by_gcm_token(gcm_token)
mobile_device ||= MobileDevice.create(:gcm_token => gcm_token, :user => user3)


users.each do | user |
  user.smart_products << water_sensor if !user.smart_products.include? water_sensor
  user.smart_products << fire_sensor if !user.smart_products.include? fire_sensor
  user.save
end

Detection.destroy_all
detection1 = Detection.create(:notification => "Water Leak", :smart_product => water_sensor, :duration_in_seconds => 30, :category => water_sensor.type_of_smart_product, :date_occurred => Date.today.strftime("%b %d"))
detection1.users << water_sensor.users
detection2 = Detection.create(:notification => "Fire sensed", :smart_product => fire_sensor, :duration_in_seconds => 10,  :category => fire_sensor.type_of_smart_product, :date_occurred => Date.today.strftime("%b %d"))
detection2.users << fire_sensor.users


