Rails.application.routes.draw do
  get "daily_tasks/update"
  devise_for :users, skip: [ :registrations ]

  authenticate :user do
    resources :buildings do
      resources :services, shallow: true do
        resources :daily_tasks
        resources :participants, controller: "service_participants"
      end
    end
  end
end
