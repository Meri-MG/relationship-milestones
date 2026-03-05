Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest"       => "rails/pwa#manifest",       as: :pwa_manifest

  root "dashboard#index"
  get "dashboard", to: "dashboard#index", as: :dashboard

  resources :relationships, only: [:new, :create, :show] do
    member do
      patch :end_chapter
      post  :new_chapter
    end

    resources :milestones,  except: [:index]
    resources :reflections, only:   [:index, :create, :update, :destroy]
    resource  :insights,    only:   [:show], controller: "insights"
  end
end
