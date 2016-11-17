FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "user_#{n}@spec.com"}
    password "password"
    password_confirmation "password"
  end

  factory :admin do
    sequence(:email){|n| "admin_#{n}@spec.com"}
    password "password"
    password_confirmation "password"
  end
end
