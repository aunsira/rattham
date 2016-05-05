Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :tasks
      scope 'tasks/:id' do
        put 'update_status', to: 'tasks#set_status'
      end
    end
  end
end
