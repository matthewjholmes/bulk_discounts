FactoryBot.define do
  factory :bulk_discount do
    association :merchant
    percentage_discount { Faker::Number.unique.within(range: 10..50) }
    quantity_threshold  { Faker::Number.unique.within(range: 5..25) }
  end
end
