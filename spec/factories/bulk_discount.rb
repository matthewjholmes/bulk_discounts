FactoryBot.define do
  factory :bulk_discount do
    association :merchant
    percentage_discount { Faker::Number.within(range: 10..50) }
    quantity_threshold  { Faker::Number.within(range: 5..250) }
  end
end
