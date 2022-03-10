# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    notice { 'Notice' }
    temperature { 1 }
    user { create(:user) }
    city { 'Warszawa' }
  end
end
