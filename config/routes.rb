require 'sidekiq/web'
require 'sidekiq/cron/web'
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :weather do
    collection do
      get 'current'
      
      scope 'historical' do
        get '', to: 'weather#historical'
        get 'max', to: 'weather#max'
        get 'min', to: 'weather#min'
        get 'avg', to: 'weather#avg'
      end
      
      get 'by_time'
    end
  end
end
