class SmartProduct < ActiveRecord::Base


  has_many :user_smart_products
  has_many :detections
  has_many :users, through: :user_smart_products

  validates_uniqueness_of :serial_no
  validates_presence_of :serial_no, :type_of_smart_product

  def self.post_example

    uri = URI('http://localhost:3000/smart_products')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    headers = {
        'Content-Type' => 'application/json'
    }

    post = Net::HTTP::Get.new(uri.path, headers)

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return false
    end

  end

end
