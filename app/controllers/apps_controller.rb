class AppsController < ApplicationController

  before_action :smart_product_params, only: [:register_smart_product]
  before_action :register_gcm_params, only: [:register_gcm_token]
  before_action :update_gcm_params, only: [:update_gcm_token]
  before_action :all_smart_products_params, only: [:smart_products]
  before_action :detection_params, only: [:detection]

  skip_before_filter :verify_authenticity_token


  GOOGLE_API_KEY = "AIzaSyBmWXZBpk9Ua9twgOaRcig_4jN18yjKCXM"
  GOOGLE_PROJECT_NUMBER = "1006767494593"


  def index
  end


  def detection
    detection = Detection.new
    smart_product = SmartProduct.find_by_serial_no(params[:serial_no])
    notification_message = params[:notification]
    duration = params[:duration_in_sec]

    if (smart_product.nil?)
      puts "Device is null"
      render_false
      return
    end

    detection.notification = notification_message
    detection.smart_product = smart_product
    detection.duration_in_seconds = duration
    detection.save

    users = smart_product.users
    if (users.blank?)
      puts "Users array is empty"
      render_false
      return
    end

    gcm_tokens = users.map do | user |
      user.mobile_devices.map { | mobile_device | mobile_device.gcm_token }
    end.flatten

    users.map do |user|
      puts "Posting rewards for #{user.email_address}"
      post_to_rewards user.email_address, 5, "#{smart_product.type_of_smart_product} + Detection"
    end

    unless post_to_gcm detection.notification, gcm_tokens
      "Failed to post"
      render_false
      return
    end

    render json: detection, status: :created, location: detection
  end

  def smart_products
    email_address = params[:email_address]
    if email_address
      user = User.find_by_email_address(email_address)
      render json: (user.nil?) ? Array.new : user.smart_products
    else
      render json: SmartProduct.all
    end
  end


  def register_smart_product
    email_address = params[:email_address]
    serial_no = params[:serial_no]
    type = params[:type]

    user = User.find_by_email_address(email_address)

    if (user.nil?)
      puts "User is nil"
      render_false
      return
    end

    #if smart_product exist, we will overwrite the user with the new register
    smart_product = SmartProduct.find_by_serial_no(serial_no)
    smart_product ||= SmartProduct.new(:serial_no => serial_no)
    smart_product.type_of_smart_product = type
    smart_product.users << user
    smart_product.save

    render_true
  end

  def register_gcm_token
    token = params[:token]
    email_address = params[:email_address]
    user = User.find_by_email_address(email_address)
    user ||= User.new(:email_address => email_address)
    mobile_device = MobileDevice.find_by_gcm_token(token)
    mobile_device ||= MobileDevice.new(:gcm_token => token)
    user.mobile_devices << mobile_device
    user.save
    render_true
  end

  def update_gcm_token
    old_token = params[:old_token]
    new_token = params[:new_token]

    mobile_device = MobileDevice.find_by_gcm_token(old_token)
    if (mobile_device.nil?)
      puts "No Mobile Device found with that GCM token"
      render_false
      return
    end

    mobile_device.gcm_token = new_token
    mobile_device.save
    render_true
  end

 private

  def render_false
      render :text => "Could not complete operation", :status => 400
  end

  def render_true
    render :text => "Successful", :status => 201
  end


  def post_to_rewards email_address, units, title, eventCategory = "Maintenance"
    data = {"userId" => email_address, "units" => units, "title" => title, "eventCategory" => eventCategory}
    headers = {
        'Content-Type' => 'application/json'
    }

    uri = URI('https://jarvis-services.herokuapp.com/services/rewards/event')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    post = Net::HTTP::Put.new(uri.path, headers)
    post.body = data.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return nil
    end

  end


  def post_to_gcm notification, token_array

    to = token_array
    data = {:message => notification}
    headers = {
        'project_id' => GOOGLE_PROJECT_NUMBER,
        "Authorization" => 'key=' + GOOGLE_API_KEY,
        'Content-Type' => 'application/json'
    }
    uri = URI('https://android.googleapis.com/gcm/send')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    post = Net::HTTP::Post.new(uri.path, headers)
    post.body = { 'data' => data, 'registration_ids' => to}.to_json

    res = http.request(post)

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return nil
    end
  end

  def smart_product_params
    params.require(:token)
    params.require(:serial_no)
    params.require(:type)
  end

  def register_gcm_params
    params.require(:email_address)
    params.require(:token)
  end

  def update_gcm_params
    params.require(:old_token)
    params.require(:new_token)
  end

  def all_smart_products_params
    params.permit(:email_address)
  end

  def detection_params
    params.require(:serial_no)
    params.require(:notification)
  end

end
