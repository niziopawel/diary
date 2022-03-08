FactoryBot.define do
  factory :post do
    notice { "MyText" }
    temperature { 1 }
    user { nil }
    city { "MyString" }
  end
end
