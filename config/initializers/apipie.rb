require 'byebug'
Apipie.configure do |config|
  config.app_name                = "Jarvis Detection API"
  config.default_version = "1"
  config.api_base_url            = ""
  config.doc_base_url            = "/api"
  config.app_info["1.0"] = "
    This is where you can inform user about your application and API
    in general.
  "
  # were is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end