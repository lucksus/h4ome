FactoryGirl.define do
  factory :user do
    passwd = Faker::Internet.password
    username                { Faker::Internet.user_name }
    email                   { Faker::Internet.email }
    password                passwd
    password_confirmation   passwd
    home_hash               { Faker::Internet.hash }
  end
end
