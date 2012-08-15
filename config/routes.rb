NicoChart::Application.routes.draw do

  constraints(:host => 'http://warm-wave-7186.herokuapp.com/') do
    root :to => redirect("http://vocaloid.anifag.com/")
    match '/*path', :to => redirect {|params| "http://vocaloid.anifag.com/#{params[:path]}"}
  end

  root :to => 'static_pages#home'

  match '/ranking/weekly/fav' => 'charts#favorites'
  match '/ranking/weekly/views' => 'charts#views'
  match '/ranking/weekly/comments' => 'charts#comments'
  match '/ranking/weekly/mylist' => 'charts#mylist'

  match '/ranking/daily/fav' => 'daily_charts#favorites'
  match '/ranking/daily/views' => 'daily_charts#views'
  match '/ranking/daily/comments' => 'daily_charts#comments'
  match '/ranking/daily/mylist' => 'daily_charts#mylist'

  match '/ranking/monthly/fav' => 'monthly_charts#favorites'
  match '/ranking/monthly/views' => 'monthly_charts#views'
  match '/ranking/monthly/comments' => 'monthly_charts#comments'
  match '/ranking/monthly/mylist' => 'monthly_charts#mylist'

  match '/ranking/total/fav' => 'total_charts#favorites'
  match '/ranking/total/views' => 'total_charts#views'
  match '/ranking/total/comments' => 'total_charts#comments'
  match '/ranking/total/mylist' => 'total_charts#mylist'    

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
