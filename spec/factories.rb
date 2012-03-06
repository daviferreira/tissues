FactoryGirl.define do
  factory :user do
    name     "Example User"
    email    "user@example.com"
    password "foobar"
  end
  
  Factory.sequence :email do |n|
    "person-#{n}@example.com"
  end

  Factory.sequence :name do |n|
    "Person #{n}"
  end
  
  factory :project do
    name "Sample Project"
    status "active"
    user
  end
end