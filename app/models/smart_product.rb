class SmartProduct < ActiveRecord::Base
  has_many :detections, :dependent => :nullify
  has_and_belongs_to_many :users

  validates_uniqueness_of :serial_no
  validates_presence_of :serial_no, :type_of_smart_product

  def self.post_example

    uri = URI('http://localhost:3000/delete_smart_product')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
        'Content-Type' => 'application/json'
    }

    data = {
        'serial_no' => 'd00001',
        'email_address' => 'test2@test.com'
    }

    post = Net::HTTP::Delete.new(uri.path, headers)
    post.body = data.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return res.body
    end

  end

end
