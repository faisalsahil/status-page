StatusPage::Application.routes.draw do
  

  

  # get "notifications/index"

  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  root :to => 'home#index'
  get "home/dashboard", to: "home#dashboard"
  # get "home/customizepage", to: "home#customizepage"
  
  get "/customizepages/theme2", to: "customizepages#theme2"

  get "/customizepages/history", to: "customizepages#history"

  get "/customizepages/customhtml", to: "customizepages#customhtml"
  get '/customizepages/:id', to: 'customizepages#theme2', as: 'mypage'

  match 'switch_user' => 'switch_user#set_current_user'

  resources :maintenance

  resources :users do
    member do
      get "incident"
      post "typeChange"
      get "settings"
      get "subscribers"
      put "saveTime"
      put "saveHistory"
      put "status"
      put "state"
      put 'addcustomurl'
      post "delete_subscriber"
      post "delete_client"
      put "saveNotificationFormats"
    end
  end
  resources :home do
    member do
      get "status_change"
    end
  end

  resources :metrics do
    collection do
      post 'pingdom_auth'
      post 'siteuptime_auth'
      post 'add_metric'
      put "pingdom_auth_update"
      put "siteuptime_auth_update"
      get 'get_options'
    end
    member do
      delete 'destroy_pingdom_link'
      delete 'destroy_siteuptime_link'
      post 'unload_metric'
    end
  end
  resources :payments do
    member do
      get "update_plan"
    end
  end
  resources :plans
  resources :datasources
  resources :customizepages do
    member do
      put "css_html_update"
      post "subscribe"
      post "smsSubscribe"   
    end
    # collection do
    #   get "history"
    # end  
  end
  resources :components do
    member do
      get "update_component"
      
    end
    collection do
      get "update_by_email"
    end
  end
  resources :incidents do
    collection do 
      get "get_component_status"
    end  
    member do
      get "update_incident"
    end
  end
  resources :pingdomprocess
  resources :resources do
    member do
      get "embed"
    end
  end

  resources :notifications do
    member do
      get "sendIncidentEmail"
      get "sendComponentEmail"
      get "sendComponentTweet"
      get "sendIncidentTweet"
      get "send_component_sms"
      get "send_incident_sms"

    end
  end


get "/:userurl" => "customizepages#theme2"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end


