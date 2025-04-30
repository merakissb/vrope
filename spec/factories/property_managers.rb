FactoryBot.define do
  factory :property_manager do
    name { Faker::Company.unique.name }
  end
end
