Rails.application.routes.draw do
  get "daily_tasks/update"
  devise_for :users, skip: [ :registrations ]

  authenticate :user do
    resources :buildings do
      resources :services, shallow: true do
        resources :daily_tasks, only: %i[ show update ]
        resources :service_participants, only: %i[create destroy]
      end
    end
  end
end
