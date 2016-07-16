class AllowanceDetail < ApplicationRecord
  belongs_to :level
  belongs_to :employee
  belongs_to :allowance
end
