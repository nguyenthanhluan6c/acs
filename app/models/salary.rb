class Salary < Employee
  scope :includes_categories, -> {includes :category}
  class << self
    def all
      super
    end
  end
end
