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
      [["Health allowance", "health_allowance", 500000],["Home allowance", "home_allowance", 300000]].each do |display_name, key, value|
        AdminSetting.create display_name: display_name, name: key, value: value
      end

      puts "Creating allowance"
      ["N", "TOEIC", "RUBY"].each do |name|
        allowance = Allowance.create name: name
        1..5.times do |n|
          Level.create level: n, value: n*200000, allowance: allowance
        end
      end

      [
        {name: "home_allowance", display_name: "Home allowance", table_expression: "admin_settings.value, name: home_allowance", index: "A"},
        {name: "health_allowance", display_name: "Health allowance", table_expression: "admin_settings.value, name: health_allowance", index: "B"}
      ].each do |column|
        Column.create name: column[:name], display_name: column[:display_name],
        table_expression: column[:table_expression], index: column[:index]
      end

      [
        {name: "lunch_allowance", display_name: "Lunch allowance", expression: "1+2+4+ROUND(10/3,2)", index: ""},
        {name: "beauty_allowance", display_name: "Beauty allowance", expression: "10/2+2-3*SUM(1,3,6)", index: ""},
        {name: "trans_allowance", display_name: "Trans allowance", expression: "3^2+2*4", index: ""},
        {name: "home_allowance", display_name: "Home allowance", expression: "A", index: "AA"},
        {name: "health_allowance", display_name: "Health allowance", expression: "B", index: "AB"}
      ].each do |formula|
        Formula.create name: formula[:name], display_name: formula[:display_name],
        expression: formula[:expression], index: formula[:index]
      end

      all_formulas = Formula.all
      all_levels = Level.all
      Employee.all.each do |employee|
        trans_allowance = rand(10)*100000
        beauty_allowance = rand(10)*100000
        lunch_allowance = rand(10)*100000
        bicycle_allowance = rand(10)*100000
        Benefit.create employee: employee, trans_allowance: trans_allowance,
          beauty_allowance: beauty_allowance, lunch_allowance: lunch_allowance,
          bicycle_allowance: bicycle_allowance

        AllowanceDetail.create employee: employee, level: all_levels.sample

        payslip = Payslip.create employee: employee, time: Date.current.beginning_of_month
        all_formulas.each do |formula|
          PayslipDetail.create payslip: payslip, detail_type: :formula, formula: formula
        end
      end

      puts "Completed rake data"
    else
      puts "Can rake db:remake in development & staging environments only"
    end
  end

  desc "Creating admin"
  task create_admin: :environment do
    User.create email: "admin@framgia.com",
      password: "123456789", password_confirmation: "123456789", role: :admin
  end
end
