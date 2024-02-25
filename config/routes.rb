Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]
  devise_for :users
  
  # resources :lessons <- All lessons have context of what course they are in.
  # That's why we want this to be nested.
  resources :courses do
    # This is to add course_lesson_path
    # For example: http://localhost:3000/courses/1/lessons/1
    # This messes up something else "edit_lesson_path"
    resources :lessons
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Where devise routes admins to after login
  authenticated :admin_user do
    root to: "admin#index", as: :admin_root
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Now can do /admin to get to index
  get "admin" => "admin#index"

  # Defines the root path route ("/")
  root "courses#index"

  # Create checkout route
  resources :checkouts, only: [:create]

  # Stripe webhook
  post "/webhook" => "webhooks#stripe"

  # Admin namespace
  namespace :admin do
    # Here everything is prefixed with admin module
    resources :courses do
      resources :lessons
    end
  end

  patch "/admin/course/:course_id/lessons/:id/move" => "admin/lessons#move"
end
