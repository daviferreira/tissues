FactoryGirl.define do
  factory :user do
    name     "Example User"
    email    "user@example.com"
    password "foobar"
    avatar   nil
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end

  sequence :name do |n|
    "Person #{n}"
  end

  factory :project do
    name "Sample Project"
    url "http://www.example.com"
    status "active"
    user
  end

  factory :issue do
    content "Big issue"
    status "pending"
    project
    user
  end

  factory :comment do
    body "First!"
    parent nil
    commentable nil
    user
  end
end