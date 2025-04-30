FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'Password123!' }
    password_confirmation { 'Password123!' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    second_last_name { Faker::Name.last_name }
    rut { Faker::Number.number(digits: 8).to_s + "-#{[ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K' ].sample}" }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
    role { :basic }

    trait :admin do
      role { :admin }
    end

    trait :client do
      role { :client }
    end
  end
end
