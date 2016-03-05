class AppsController < ApplicationController

  before_action :smart_product_params, only: [:register_smart_product]
  before_action :register_gcm_params, only: [:register_gcm_token]
  before_action :update_gcm_params, only: [:update_gcm_token]
  before_action :all_smart_products_params, only: [:smart_products]
  before_action :new_detection_params, only: [:new_detection]
  before_action :index_detection_params, only: [:index_detection]
  before_action :mobile_devices_params, only: [:mobile_devices]
  before_action :delete_smart_params, only: [:delete_smart_product]

  skip_before_filter :verify_authenticity_token


  GOOGLE_API_KEY = "AIzaSyBVpdUG9dxuMqX0LAPjhr1BUlWQuhw4zzU"
  GOOGLE_PROJECT_NUMBER = "610693176944"


  def index
    redirect_to "/api/1/apps.html"
  end

  api :POST, "/detection/:format", "Submit a new Detection. <br/>View method <a href='/doc/AppsController.html#method-i-new_detection'>here</a>"
  param :notification, String, :required => true, :desc => "Message Notification"
  param :serial_no, String, :required => true, :desc => "Serial Number of smart product that made the detection"
  param :duration_in_sec, String, :required => true, :desc => "Duration of detection"
  def new_detection
    detection = Detection.new
    smart_product = SmartProduct.find_by_serial_no(params[:serial_no])
    notification = params[:notification]
    duration = params[:duration_in_sec].to_i

    if (smart_product.nil?)
      logger.info "Device is null"
      render_false
      return
    end
    users = smart_product.users
    if (users.blank?)
      logger.info "Users array is empty"
      render_false
      return
    end

    detection.notification = notification
    detection.smart_product = smart_product
    detection.duration_in_seconds = duration
    detection.date_occurred = Date.today.strftime("%b %d")
    detection.category = smart_product.type_of_smart_product
    detection.save
    detection.users << users

    gcm_tokens = users.map do | user |
      user.mobile_devices.map { | mobile_device | mobile_device.gcm_token }
    end.flatten

    users.map do |user|
      logger.info "Posting rewards for #{user.email_address}"
      post_to_rewards user.email_address, "5", "#{smart_product.type_of_smart_product} Detection"
    end

    logger.info "About to post to gcm"
    logger.info "Gcm tokens #{gcm_tokens}"
    data = {:message => notification, :appliance_name => detection.smart_product.appliance_name, :date => detection.date_occurred, :category => detection.category, :duration_in_sec => duration}
    logger.info "What I am about to send to gcm: #{data}"

    unless post_to_gcm data, gcm_tokens
      "Failed to post"
      render_false
      return
    end

    render_true
  end


  api :GET, "/detections/:format", "Get all detections per user.</br>View method <a href='/doc/AppsController.html#method-i-index_detection'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address to filter by"
  param :type, String, :desc => "Filter detections by type of detection, i.e. water"
  def index_detection
    email_address = params[:email_address]
    type = params[:type]
    user = User.find_by_email_address(email_address)

    array = if (user.nil?)
      Array.new
    else
      type.nil? ? user.detections : user.detections.find_all { |detection| detection.smart_product.type_of_smart_product == type}
    end

    render json: array
  end

  api :GET, "/mobile_devices/:format", "Get all mobile devices per user."
  api :GET, "/gcm_tokens/:format", "Get all gcm_tokens per user. </br>View method <a href='/doc/AppsController.html#method-i-mobile_devices'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address to filter by"
  def mobile_devices
    email_address = params[:email_address]
    user = User.find_by_email_address(email_address)
    render json: (user.nil?) ? Array.new : user.mobile_devices
  end

  api :GET, "/smart_products/:format", "Get all smart products per user </br>View method <a href='/doc/AppsController.html#method-i-smart_products'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address to filter by"
  def smart_products
    email_address = params[:email_address]
    if email_address
      user = User.find_by_email_address(email_address)
      render json: (user.nil?) ? Array.new : user.smart_products
    else
      render json: SmartProduct.all
    end
  end

  api :GET, "/smart_products_count/:format", "Get all smart products per user </br>View method <a href='/doc/AppsController.html#method-i-smart_products'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address to filter by"
  def smart_products_count
    email_address = params[:email_address]
    user = User.find_by_email_address(email_address)
    if (user.nil?)
      render_false
      return
    end
    render json: {:total_smart_products => user.smart_products.count}
  end

  api :POST, "/register_smart_product/:format", "Register smart product. </br>View method <a href='/doc/AppsController.html#method-i-register_smart_product'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address smart product will be registered under. Multiple users can share similar smart products"
  param :serial_no, String, :required => true, :desc => "Serial number of smart product"
  param :type_of_smart_product, String, :required => true, :desc => "The type of smart product, i.e. water"
  param :appliance_name, String, :desc => "The type of smart product, i.e. water"
  def register_smart_product
    email_address = params[:email_address]
    serial_no = params[:serial_no]
    type = params[:type_of_smart_product]
    appliance_name = params[:appliance_name]

    user = User.find_by_email_address(email_address)

    if (user.nil?)
      logger.info "User is nil"
      render_false
      return
    end

    #if smart_product exist, we will overwrite the user with the new register
    smart_product = SmartProduct.find_by_serial_no(serial_no)
    if (smart_product.nil?)
      logger.info "Smart Product is nil"
      render_false
      return
    end
    smart_product.type_of_smart_product ||= type
    smart_product.appliance_name = appliance_name
    smart_product.users << user if !smart_product.users.include? user
    if (smart_product.save)
      post_to_rewards user.email_address, "5", "Registered #{smart_product.toString}"
      render :json => smart_product
    else
      render_false
    end
  end

  api :DELETE, "/delete_smart_product/:format", "Delete smart product </br>View method <a href='/doc/AppsController.html#method-i-delete_smart_product'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address of user"
  param :serial_no, String, :required => true, :desc => "Serial no of user"
  def delete_smart_product
    email_address = params[:email_address]
    serial_no = params[:serial_no]

    user = User.find_by_email_address(email_address)

    if (user.nil?)
      logger.info "User is nil"
      render_false
      return
    end

    smart_product = SmartProduct.find_by_serial_no(serial_no)
    user.smart_products.delete smart_product
    if user.save
      render_true
    else
      logger.debug "Could not save #{user.errors.inspect}"
      puts "Could not save #{user.errors.inspect}"
      render_false
    end
  end

  api :POST, "/register_gcm_token/:format", "Register gcm token/mobile device."
  api :POST, "/register_mobile_device/:format", "Register mobile device/gcm token. </br>View method <a href='/doc/AppsController.html#method-i-register_gcm_token'>here</a>"
  param :email_address, String, :required => true, :desc => "Email address token will be registered under"
  param :token, String, :required => true, :desc => "Token for mobile device generated from GCM"
  def register_gcm_token
    token = params[:token]
    email_address = params[:email_address]
    user = User.find_by_email_address(email_address)
    user ||= User.new(:email_address => email_address)
    mobile_device = MobileDevice.find_by_gcm_token(token)
    mobile_device ||= MobileDevice.new(:gcm_token => token)
    mobile_device.user = user
    user.save
    if mobile_device.save
      render json: mobile_device
    else
      logger.debug "Could not save #{mobile_device.errors.inspect}"
      puts "Could not save #{mobile_device.errors}"
      render_false
    end
  end

  api :POST, "/update_gcm_token/:format", "Update GCM Token/Mobile device."
  api :POST, "/update_mobile_device/:format", "Register mobile device/gcm token. </br>View method <a href='/doc/AppsController.html#method-i-update_gcm_token'>here</a>"
  param :old_token, String, :required => true, :desc => "Old GCM Token"
  param :new_token, String, :required => true, :desc => "New GCM Token"
  def update_gcm_token
    old_token = params[:old_token]
    new_token = params[:new_token]

    mobile_device = MobileDevice.find_by_gcm_token(old_token)
    if (mobile_device.nil?)
      logger.info "No Mobile Device found with that GCM token"
      puts "No Mobile Device found with that GCM token"
      render_false
      return
    end

    mobile_device.gcm_token = new_token
    if mobile_device.save
      render :json => mobile_device
    else
      logger.debug "Could not save #{mobile_device.errors.inspect}"
      puts "Could not save #{mobile_device.errors}"
      render_false
    end
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
    logger.info res.body

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        return nil
    end

  end


  def post_to_gcm data, token_array

    to = token_array
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
    logger.info "result from gcm #{res.body}"
    logger.info "status from gcm #{res}"

    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return res.body
      else
        return nil
    end
  end

  def smart_product_params
    params.require(:serial_no)
    params.require(:type_of_smart_product)
    params.permit(:appliance_name)
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

  def new_detection_params
    params.require(:serial_no)
    params.require(:notification)
  end

  def index_detection_params
    params.require(:email_address)
    params.permit(:type_of_smart_product)
  end

  def mobile_devices_params
    params.require(:email_address)
  end

  def delete_smart_params
    params.require(:email_address)
    params.require(:serial_no)
  end

end
