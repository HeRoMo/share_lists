FactoryGirl.define do
  factory :list do
    sequence(:title){|n|"リストの題名-#{n}"}
    items "1項目\n2項目\3項目"
    association :owner, factory: :user
  end
end
