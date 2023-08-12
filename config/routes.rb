Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'campaigns#index'

  # characters
  get '/characters/new', to: 'characters#new', as: 'new_characters'
  post '/characters', to: 'characters#create', as: 'characters'
  get '/characters/:id', to: 'characters#show', as: 'character'

  #campaigns
  post '/campaigns', to: 'campaigns#new', as: 'new_campaign'
  get '/campaigns', to: 'campaigns#index'
  get '/campaigns/:id', to: 'campaigns#show', as: 'campaign'

  # #invitations
  # post 'campaigns/:campaign_id/invitations', to: 'campaigns#create', as: 'invitations'
  # post '/invitations/:id/accept', to: 'invitations#accept', as: 'accept_invitation'
  # post '/invitations/:id/decline', to: 'invitations#decline', as: 'decline_invitation'

  # #campaign_session
  # post '/campaigns/:campaign_id/sessions', to: 'sessions#create', as: 'new_session'
  # post '/campaign_sessions/:session_id/join', to: 'campaign_session#join', as: 'join_campaign'
  # post '/campaign_sessions/:id/save', to: 'sessions#update', as: 'save_session'
  # get '/campaign_sessions/:id', to: 'sessions#show', as: 'session'
end
