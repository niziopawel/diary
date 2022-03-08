# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    email { 'test_user@email.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
