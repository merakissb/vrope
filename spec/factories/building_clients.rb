# spec/factories/building_clients.rb
FactoryBot.define do
  factory :building_client do
    association :user, factory: [ :user, :client ]
    association :building
  end
end
