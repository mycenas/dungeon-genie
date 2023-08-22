Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'pages#home'

  # characters
  get '/my_characters', to: 'characters#my_characters', as: 'my_characters'
  get '/characters/new', to: 'characters#new', as: 'new_character'
  post '/characters', to: 'characters#create', as: 'characters'
  get '/characters/:id', to: 'characters#show', as: 'character'

  #campaigns
  get '/my_campaigns', to: 'campaigns#my_campaigns', as: 'my_campaigns'
  post '/campaigns', to: 'campaigns#create', as: 'new_campaign'
  get '/campaigns/:id', to: 'campaigns#show', as: 'campaign'

  #campaign_options
  get '/campaign_options', to: 'campaign_options#index', as: 'campaign_options'

  # campaign_sessions within campaigns
  get '/campaigns/:campaign_id/sessions/new', to: 'campaign_sessions#new', as: 'new_campaign_session'
  post '/campaigns/:campaign_id/sessions', to: 'campaign_sessions#create', as: 'campaign_sessions'
  get '/campaigns/:campaign_id/sessions/:id', to: 'campaign_sessions#show', as: 'campaign_session'

  # #invitations
  # post 'campaigns/:campaign_id/invitations', to: 'campaigns#create', as: 'invitations'
  # post '/invitations/:id/accept', to: 'invitations#accept', as: 'accept_invitation'
  # post '/invitations/:id/decline', to: 'invitations#decline', as: 'decline_invitation'

end
