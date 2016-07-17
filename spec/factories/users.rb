FactoryGirl.define do
  factory :user do
    sequence(:email){|i| "user#{i}@framgia.com"}
    password "123456789"
    password_confirmation "123456789"

    trait :hr do
      email "hr@framgia.com"
      password "123456789"
      password_confirmation "123456789"
      role :hr
    end
  end
end
