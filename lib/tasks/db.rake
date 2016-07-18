namespace :db do
  desc "Remaking data"
  task remake_data: :environment do
    if Rails.env.development? || Rails.env.staging?
      Rake::Task["db:migrate:reset"].invoke

      puts "Creating admin"
      Rake::Task["db:create_admin"].invoke

      puts "Creating categories"
      ["DIV1", "DIV2", "DIV3", "EDU", "BO", "HR", "INFRA"].each do |name|
        FactoryGirl.create :category, name: name
      end

      puts "Creating hr"
      FactoryGirl.create :user, :hr

      puts "Creating users"
      50.times do
        user = FactoryGirl.create :user
        employee = FactoryGirl.create :employee, email: user.email
        user.update_attributes employee: employee
      end

      puts "Creating admin settings"
      [["Health allowance", 500000],["Home allowance", 300000]].each do |key, value|
        AdminSetting.create name: key, value: value
      end

      puts "Creating allowance"
      ["N", "TOEIC", "RUBY"].each do |name|
        allowance = Allowance.create name: name
        1..5.times do |n|
          Level.create level: n, value: n*200000, allowance: allowance
        end
      end

      Employee.all.each do |employee|
        trans_allowance = rand(10)*100000
        beauty_allowance = rand(10)*100000
        lunch_allowance = rand(10)*100000
        bicycle_allowance = rand(10)*100000
        Benefit.create employee: employee, trans_allowance: trans_allowance,
          beauty_allowance: beauty_allowance, lunch_allowance: lunch_allowance,
          bicycle_allowance: bicycle_allowance
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
