Rails.application.routes.draw do
  root "welcome#index"

  resources :calls, only: [:create]

  post '/step0/:user', to: 'welcome#step0'
  post '/step1/:user', to: 'welcome#step1'
  post '/step2/:user', to: 'welcome#step2'
  post '/step2retry/:user', to: 'welcome#step2retry'
  post '/step3/:user', to: 'welcome#step3'
  post '/step4/:user', to: 'welcome#step4'
  post '/step5/:user', to: 'welcome#step_dragon'

  post '/stepwin/:user', to: 'welcome#win'
  post '/stepdead/:user', to: 'welcome#dead'
end
