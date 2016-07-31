class PayslipDetail < ApplicationRecord
  attr_accessor :cached_payslip

  has_many :payslip_details
  belongs_to :payslip
  belongs_to :formula

  enum detail_type: [:column, :formula]

  delegate :name, to: :formula, prefix: true

  def caculated_result
    result ||= formula.excute_value @cached_payslip.caculation_service
  end
end
