FactoryGirl.define do
  factory :employee do
    name {Faker::Name.name}   
    uid {"U#{rand(1000)}"}
    insurance {[true, false].sample}
    personal_deduction {[true, false].sample}
    number_of_dependence {rand 3}
    base_salary {rand(1..20)*100000}
    category_id {Category.pluck(:id).sample}
  end
end
