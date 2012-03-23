namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    User.create!(name: "Example User",
                 email: "example@foo.org",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@foo.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    50.times do
      name = Faker::Lorem.sentence(5)
      users.each { |user| user.projects.create!(name: name, status: "active") }
    end

    projects = Project.all(limit: 6)
    user = User.first
    50.times do
      content = Faker::Lorem.sentence(10)
      projects.each { |project| user.issues.create!(content: content, who_is_solving: Random.rand(11), 
                                                       who_is_validating: Random.rand(11), project_id: project.id) }
    end
    
  end
end