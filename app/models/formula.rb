class Formula < ApplicationRecord
  ATTRIBUTES_PARAMS = [:display_name, :name, :expression, :index]
  has_many :payslip_details, dependent: :destroy
  has_many :payslips, through: :payslip_details

  scope :of_payslips, -> payslips do
    ids = PayslipDetail.where(payslip: payslips).distinct.pluck(:formula_id)
    where(id: ids)
  end

  def excute_value payslip_caculation_service
    payslip_caculation_service.calc_expression expression rescue nil
  end
end
