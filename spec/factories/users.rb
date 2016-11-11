FactoryGirl.define do
  factory :user do
    email "whatever@whatever.com"
    password "secret"
    password_confirmation "secret"
  end
end
