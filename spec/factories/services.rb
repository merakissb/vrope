FactoryBot.define do
  factory :service do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    start_date { 2.days.from_now }
    end_date { 5.days.from_now }
    association :building
  end
end
