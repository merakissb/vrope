FactoryBot.define do
  factory :building do
    name { Faker::Address.community }
    rut { Faker::Number.number(digits: 8).to_s + "-#{['0','1','2','3','4','5','6','7','8','9','K'].sample}" }
    address_reference { Faker::Address.full_address }
    floors { Faker::Number.between(from: 1, to: 50) }
    underground_floors { Faker::Number.between(from: 0, to: 5) }
    association :property_manager
  end
end
