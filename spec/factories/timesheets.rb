FactoryGirl.define do
  factory :timesheet do
    time "2016-07-16"
    employee nil
    vacation_with_salary 1.5
    vacation_without_salary 1.5
    total_vacation_with_insurance_fee 1.5
  end
end
