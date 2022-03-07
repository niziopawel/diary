# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    authenticated { root to: 'posts#index', as: :autenticated_root }
    unauthenticated { root to: 'devise/sessions#new', as: :unautenticated_root }
  end
end
