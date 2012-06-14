ScienceJournal::Application.routes.draw do
  root :to => 'pages#home'
  resources :authors, except: [:index, :destroy]
  resources :articles, except: [:destroy]
  resources :journals, except: [:edit, :update, :destroy] do
    resources :articles, only: [:show]
  end
  resources :categories, except: [:show] do
    collection do
      post :rebuild
    end
  end

  devise_for :users
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
    get "/logout" => "devise/sessions#destroy"
  end
  match '/users' => 'users#index', as: :all_users, via: :get
  match '/users/show' => 'users#show', as: :show_user, via: :get
  match '/users/show/:id' => 'users#show', as: :show_user, via: :get
  match '/update_users' => 'users#update_without_password', as: :update_without_password, via: :put

  match '/profile/show' => 'profile#show', as: :show_profile, via: :get
  match '/profile/edit_personal' => 'profile#edit_personal_info', as: :edit_personal, via: :get
  match '/profile/update' => 'profile#update', as: :update_personal, via: :put
  match '/search' => 'search#search', via: :get

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
