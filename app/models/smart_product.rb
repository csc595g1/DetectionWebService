class SmartProduct < ActiveRecord::Base
  has_many :detections, :dependent => :nullify
  has_and_belongs_to_many :users

  validates_uniqueness_of :serial_no
  validates_presence_of :serial_no, :type_of_smart_product

  def toString
    appliance_name = self.appliance_name
    string = "#{self.type_of_smart_product} sensor"
    (appliance_name) ? "#{string} for #{appliance_name}" :  "#{string}"
  end
  private
  base_prod_uri = 'http://detectionservices.herokuapp.com'
  base_dev_uri = 'http://localhost:3000'
  BASE_URI = base_dev_uri

  # Test Detection
  def self.new_detection_post

    uri = URI("#{BASE_URI}/detection")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
        'Content-Type' => 'application/json'
    }

    data = {
        'serial_no' => 'd00001',
        'notification' => 'Water Leak',
        'duration_in_sec' => '2'
    }

    post = Net::HTTP::Post.new(uri.path, headers)
    post.body = data.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return res.body
    end

  end

  def self.register_smart_product

    uri = URI("#{BASE_URI}/register_smart_product")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
        'Content-Type' => 'application/json'
    }

    data = {
        'serial_no' => 'd00003',
        'type_of_smart_product' => 'water',
        'appliance_name' => 'Kitchen',
        'email_address' => 'test1@test.com'

    }

    post = Net::HTTP::Post.new(uri.path, headers)
    post.body = data.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return res.body
    end

  end

  def self.register_smart_product_no_appliance

    uri = URI("#{BASE_URI}/register_smart_product")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
        'Content-Type' => 'application/json'
    }

    data = {
        'serial_no' => 'X000LP8W23',
        'type_of_smart_product' => 'water',
        'email_address' => 'test1@test.com'

    }

    post = Net::HTTP::Post.new(uri.path, headers)
    post.body = data.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return res.body
    end

  end

  def self.new_smart_product_restful

    uri = URI("#{BASE_URI}/users/test1@test.com/smart_products/new")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = false
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    headers = {
        'Content-Type' => 'application/json'
    }

    data = {
        'serial_no' => 'd00004',
        'type_of_smart_product' => 'water',
        'appliance_name' => 'Sump Pump'

    }

    post = Net::HTTP::Post.new(uri.path, headers)
    post.body = data.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return res.body
    end

  end

  def self.get_smart_products

    uri = URI("#{BASE_URI}/users/test1@test.com/smart_products")
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
        puts res.body
        return true
      else
        return res.body
    end

  end

  def self.get_detections

    uri = URI("#{BASE_URI}/users/test1@test.com/detections")
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
        puts res.body
        return true
      else
        return res.body
    end

  end



  def self.delete_smart_product

    uri = URI("#{base_uri}/delete_smart_product")
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
