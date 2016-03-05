Rails.application.routes.draw do

  VALID_EMAIL_REGEX = /.+@.+\..*/

  apipie

  root 'apps#index'

  post '/detection' => 'apps#new_detection'
  post '/register_smart_product' => 'apps#register_smart_product'
  match "/users/:email_address/smart_products/new", :to => 'apps#register_smart_product', constraints: {email_address: VALID_EMAIL_REGEX}, via: :post


  post '/register_mobile_device' => 'apps#register_gcm_token'
  post '/register_gcm_token' => 'apps#register_gcm_token'
  match "/users/:email_address/gcm_tokens/:token/new", :to => 'apps#register_gcm_token', constraints: {email_address: VALID_EMAIL_REGEX}, via: :post


  post '/update_mobile_device' => 'apps#update_gcm_token'
  post '/update_gcm_token' => 'apps#update_gcm_token'
  match "/update_gcm_token/:old_token/:new_token", :to => 'apps#update_gcm_token', via: :post


  get '/smart_products' => 'apps#smart_products'
  match "/users/:email_address/smart_products", :to => 'apps#smart_products', constraints: {email_address: VALID_EMAIL_REGEX}, via: :get

  get '/smart_products/count' => 'apps#smart_products_count'
  match "/users/:email_address/smart_products/count", :to => 'apps#smart_products_count', constraints: {email_address: VALID_EMAIL_REGEX}, via: :get



  get '/detections' => 'apps#index_detection'
  match "/users/:email_address/detections", :to => 'apps#index_detection', constraints: {email_address: VALID_EMAIL_REGEX}, via: :get


  get '/mobile_devices' => 'apps#mobile_devices'
  get '/gcm_tokens' => 'apps#mobile_devices'

  delete '/delete_smart_product' => 'apps#delete_smart_product'
  match "/users/:email_address/smart_products/:serial_no/delete", :to => 'apps#delete_smart_product', constraints: {email_address: VALID_EMAIL_REGEX}, via: :delete


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
