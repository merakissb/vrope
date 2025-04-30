FactoryBot.define do
  factory :contract do
    price { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    currency { %w[CLP UF USD].sample }
    start_date { Faker::Date.backward(days: 30) }
    end_date { Faker::Date.forward(days: 365) }
    association :building

    trait :with_pdf do
      after(:build) do |contract|
        contract.file.attach(
          io: File.open(Rails.root.join('spec/fixtures/files/sample.pdf')),
          filename: 'contract.pdf',
          content_type: 'application/pdf'
        )
      end
    end
  end
end
