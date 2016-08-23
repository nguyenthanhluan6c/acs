class Salary < Employee
  ATTRIBUTES_PARAMS = [:base_salary, :insurance, :personal_deduction,
    :number_of_dependence]

  scope :includes_categories, -> {includes :category}
  class << self
    def all
      super
    end
  end
end
