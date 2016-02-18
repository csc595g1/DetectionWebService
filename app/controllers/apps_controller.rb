class AppsController < ApplicationController
  before_action :device_params, only: [:register_device]
  before_action :register_gcm_params, only: [:register_gcm_user]
  before_action :update_gcm_params, only: [:update_gcm_user]


  def detection
    detection = Detection.new
    device = Device.find_by_serial_no(params[:serial_no])
    notification_message = params[:notification]
    duration = params[:duration_in_sec]

    if (device.nil?)
      puts "Device is null"
      render_false
      return
    end

    detection.notification = notification_message
    detection.device = device
    detection.duration_in_seconds = duration
    detection.save

    render_true
  end


  def register_device
    token = params[:token]
    serial_no = params[:serial_no]
    type = params[:type]

    user = User.find_by_token(token)

    if (user.nil?)
      puts "User is nil"
      render_false
      return
    end

    #if device exist, we will overwrite the user with the new register
    device = Device.find_by_serial_no(serial_no)
    device ||= Device.new(:serial_no => serial_no)
    device.type_of_device = type
    device.user = user
    device.save

    render_true
  end

  def register_gcm_user
    user_token = params[:token]
    user = user.find_by_token(user_token)
    user ||= User.new(:token => user_token)
    user.save
    render_true
  end

  def update_gcm_user
    old_token = params[:old_token]
    new_token = params[:new_token]

    user = User.find_by_token(old_token)
    if (user.nil?)
      puts "No User found with that token"
      render_false
      return
    end

    user.token = new_token
    user.save
    render_true
  end


  def render_false
      render :text => "<p>false</p>".html_safe, :status => 200
  end

  def render_true
    render :text => "<p>true</p>".html_safe, :status => 200
  end


  def device_params
    params.require(:token)
    params.require(:serial_no)
    params.require(:type)
  end

  def register_gcm_params
    params.require(:token)
  end

  def update_gcm_params
    params.require(:old_token)
    params.require(:new_token)
  end

end
