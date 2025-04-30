FactoryBot.define do
  factory :service_participant do
    association :service
    association :user
    role { :operator }
  end

  trait :operator do
    role { 0 }
  end

  trait :supervisor do
    role { 1 }
  end

  trait :operations_manager do
    role { 2 }
  end

  trait :safety_officer do
    role { 3 }
  end
end
