namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    if Rails.env.development? || Rails.env.staging?
      Rake::Task["db:migrate:reset"].invoke

      puts "Creating admin"
      Rake::Task["db:create_admin"].invoke

      puts "Creating hr"
      FactoryGirl.create :user, :hr

      puts "Creating users"
      50.times do
        FactoryGirl.create :user
      end

      puts "Creating categories"
      ["DIV1", "DIV2", "DIV3", "EDU", "BO", "HR", "INFRA"].each do |name|
        FactoryGirl.create :category, name: name
      end

      puts "Completed rake data"
    else
      puts 'Can rake db:remake in development & staging environments only'
    end
  end

  desc "Creating admin"
  task create_admin: :environment do
    User.create email: "admin@framgia.com",
      password: "123456789", password_confirmation: "123456789", role: :admin
  end
end
