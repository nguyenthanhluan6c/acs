class Salary < Employee
  delegate :name, to: :category, prefix: true
  class << self
    def all
      super
    end
  end
end
