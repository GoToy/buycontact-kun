Rails.application.routes.draw do
  resources :users do
    member do
      post 'update_contacts', to: 'contacts#update'
      post 'show_contacts', to: 'contacts#show'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
