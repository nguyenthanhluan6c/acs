class PayslipDetail < ApplicationRecord
  belongs_to :payslip

  enum detail_type: [:column, :formula]
end
