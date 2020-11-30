# == Route Map
#
#                 Prefix Verb   URI Pattern                                     Controller#Action
#    room_player_entries POST   /api/rooms/:room_id/player_entries(.:format)    player_entries#create
#           player_entry DELETE /api/player_entries/:id(.:format)               player_entries#destroy
# room_spectator_entries POST   /api/rooms/:room_id/spectator_entries(.:format) spectator_entries#create
#        spectator_entry DELETE /api/spectator_entries/:id(.:format)            spectator_entries#destroy
#                  rooms GET    /api/rooms(.:format)                            rooms#index
#                        POST   /api/rooms(.:format)                            rooms#create
#                   room GET    /api/rooms/:id(.:format)                        rooms#show
#       game_preparation POST   /api/games/:game_id/preparation(.:format)       games#prepare
#            game_pieces GET    /api/games/:game_id/pieces(.:format)            pieces#index
#                  piece GET    /api/pieces/:id(.:format)                       pieces#show
#                        PATCH  /api/pieces/:id(.:format)                       pieces#update
#                        PUT    /api/pieces/:id(.:format)                       pieces#update
#                   game GET    /api/games/:id(.:format)                        games#show
#          user_sessions POST   /api/user_sessions(.:format)                    user_sessions#create
#           user_session DELETE /api/user_sessions/:id(.:format)                user_sessions#destroy
#                  users POST   /api/users(.:format)                            users#create
#                   user GET    /api/users/:id(.:format)                        users#show
#

Rails.application.routes.draw do
  scope :api, format: :json, shallow: true do
    resources :rooms, only: [:index, :show, :create] do
      resources :player_entries, only: [:create, :destroy]
      resources :spectator_entries, only: [:create, :destroy]
    end
    resources :games, only: [:show] do
      post :preparation, action: :prepare
      resources :pieces, only: [:index, :show, :update]
    end
    resources :user_sessions, only: [:create, :destroy]
    resources :users, only: [:show, :create]
  end
end
