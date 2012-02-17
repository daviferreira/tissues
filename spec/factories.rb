FactoryGirl.define do
  factory :user do
    name     "Example User"
    email    "user@example.com"
    password "foobar"
  end
  
  factory :project do
    name "Sample Project"
    status "active"
    user
  end
end