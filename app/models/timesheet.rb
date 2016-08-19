class Timesheet < ApplicationRecord
  ATTRIBUTES_PARAMS = [:working_day, :vacation_with_salary, :vacation_without_salary,
    :total_vacation_with_insurance_fee, over_time_detail_attributes: [:id, :total_hour]]

  has_one :over_time_detail
  has_one :over_time, through: :over_time_detail
  belongs_to :employee
  scope :includes_resources, -> {includes employee: :category}

  delegate :name, :uid, :category_name, to: :employee, prefix: false
  delegate :total_hour, to: :over_time_detail, prefix: false, allow_nil: true
  delegate :name, :percent, to: :over_time, prefix: true, allow_nil: true

  accepts_nested_attributes_for :over_time_detail
end
