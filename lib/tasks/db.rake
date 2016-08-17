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
      [
        ["Health allowance", "health_allowance", 500000],
        ["Home allowance", "home_allowance", 300000]
      ].each do |display_name, key, value|
        AdminSetting.create display_name: display_name, name: key, value: value
      end

      puts "Creating allowance"
      [["Night", 150], ["Holiday", 200], ["Night holiday", 250]].each do |name, percent|
        OverTime.create name: name, percent: percent
      end

      puts "Creating OverTimes"
      ["N", "TOEIC", "RUBY"].each do |name|
        allowance = Allowance.create name: name
        1..5.times do |n|
          Level.create level: n, value: n*200000, allowance: allowance
        end
      end

      [
        {name: "home_allowance", display_name: "Home allowance", table_expression: "admin_settings.value, name: home_allowance", index: "A"},
        {name: "health_allowance", display_name: "Health allowance", table_expression: "admin_settings.value, name: health_allowance", index: "B"},
        {name: "trans_allowance", display_name: "Trans allowance", table_expression: "benefits.trans_allowance, employee: param", index: "C"},
        {name: "n_allowance", display_name: "Japanese allowance", table_expression: "levels.value, employee: param", index: "D"}
      ].each do |column|
        Column.create name: column[:name], display_name: column[:display_name],
        table_expression: column[:table_expression], index: column[:index]
      end

      [
        {name: "lunch_allowance", display_name: "Lunch allowance", expression: "1+2+4+ROUND(10/3,2)", index: ""},
        {name: "beauty_allowance", display_name: "Beauty allowance", expression: "10/2+2-3*SUM(1,3,6)", index: ""},
        {name: "home_allowance", display_name: "Home allowance", expression: "A", index: "AA"},
        {name: "health_allowance", display_name: "Health allowance", expression: "B", index: "AB"},
        {name: "trans_allowance", display_name: "Trans allowance", expression: "C", index: "AC"},
        {name: "n_allowance", display_name: "Japanese allowance", expression: "D", index: "AD"}
      ].each do |formula|
        Formula.create name: formula[:name], display_name: formula[:display_name],
        expression: formula[:expression], index: formula[:index]
      end

      all_formulas = Formula.all
      all_levels = Level.all
      all_over_times = OverTime.all
      Employee.all.each do |employee|
        trans_allowance = rand(10)*100000
        beauty_allowance = rand(10)*100000
        lunch_allowance = rand(10)*100000
        bicycle_allowance = rand(10)*100000
        vacation_with_salary = rand(10..20)
        vacation_without_salary = rand(0..5)
        total_vacation_with_insurance_fee = rand(0..5)
        total_hour = rand(0..5)
        Benefit.create employee: employee, trans_allowance: trans_allowance,
          beauty_allowance: beauty_allowance, lunch_allowance: lunch_allowance,
          bicycle_allowance: bicycle_allowance

        AllowanceDetail.create employee: employee, level: all_levels.sample

        payslip = Payslip.create employee: employee, time: Date.current.beginning_of_month
        all_formulas.each do |formula|
          PayslipDetail.create payslip: payslip, detail_type: :formula, formula: formula
        end
        timesheet = Timesheet.create employee: employee, time: Date.current.beginning_of_month,
          vacation_with_salary: vacation_with_salary, vacation_without_salary: vacation_without_salary,
          total_vacation_with_insurance_fee: total_vacation_with_insurance_fee
        OverTimeDetail.create employee: employee, over_time: all_over_times.sample,
          timesheet: timesheet, total_hour: total_hour
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
