FactoryBot.define do
  factory :daily_task do
    date { Faker::Date.forward(days: 7) }
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :service

    trait :pending do
      status { :pending }
    end

    trait :completed do
      association :completed_by, factory: :user

      after(:build) do |task|
        task.file.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/task_image.jpg')),
          filename: 'task_image.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
