class OverTimeDetail < ApplicationRecord
  belongs_to :over_time
  belongs_to :timesheet
  belongs_to :employee
end
