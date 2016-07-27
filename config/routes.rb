Furnitureapp::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admins
  devise_for :users, :controllers => {:sessions => "sessions", :omniauth_callbacks => "omniauth_callbacks"}
  namespace :admin do
    resources :offer_managers do 
      collection do 
        put :offer_go
        put :offer_first
        put :offer_second
        put :offer_third
        put :offer_fourth
        put :offer_fifth
        put :offer_sixth
        put :offer_seventh
        put :offer_eighth
      end
    end

    resources :orders do
      collection do
        get :guest_orders
        get :user_orders
      end
      member do
        put :order_status
      end
    end
    resources :banners do 
      member do 
        put :visible
      end
    end
    resources :products do
      member do
        delete :delete_img
        put :image_show
        get :flag
      end
      collection do 
        get :load_subcats
      end
    end
    resources :categories do
      member do
        get :category_show
      end
      resources :sub_categories
    end
    resources :dashboards do
      collection do 
        get :view_graph
      end
    end
    resources :users
    resources :news_letters
    resources :profiles do
      collection do 
        get :setting
        put :update_setting
        get :edit_passcode
        put :update_passcode
      end
    end
    resources :stocks
    resources :advices do 
      member do 
        put :visible
      end
    end
    resources :guides do 
      member do 
        put :visible
      end
    end
  end
  resources :welcome 
  resources :profiles do
    member do
      put :update_profile
      put :change_password
    end
  end
  resources :homes do
    collection do
      get :offers
      get :how_to_buy
      get :faq
      get :payment
      get :shipment
      get :terms
      get :return_policy
      get :search
      get :new_news_letter
      post :post_news_letter
      get :index_test
      get :load_image
      get :measurements
      get :lining
      get :confirm
    end
    member do
      get :single_product
      get :inspirations
      get :guide
    end
  end 
  resources :line_items
  resources :carts do
    collection do
      delete :empty_carts
    end
  end
  resources :orders do
    member do
      get :confirm
      put :confirm_myorder
      put :cancel_order
    end
    collection do 
      get :myorder
      get :checkout_information
      get :success
    end
  end
  #   post '/payu_callback'=>'carts#payu_return'
  post 'payment_confirm', to: 'carts#payment_confirm', as: 'payment_confirm'

  root 'homes#index'
  devise_scope :user do
    get '/auth/:provider/callback' => 'omniauth_callbacks#facebook'
  end
  get 'signout', to: 'omniauth_callbacks#destroy', as: 'signout'

# resources :omniauth_callbacks, only: [:create, :destroy]

end