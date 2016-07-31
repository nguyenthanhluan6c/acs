class Payslip < ApplicationRecord
  belongs_to :employee
  has_many :payslip_details, ->{order formula_id: :asc}

  delegate :name, :uid, :category_name, to: :employee, prefix: true
  scope :of_month, -> date do
    beginning_of_month = date.beginning_of_month
    where time: beginning_of_month
  end
  scope :includes_resources, -> {includes payslip_details: :formula, employee: :category}

  def get_value_from_formulas index
    expression = Formula.find_by_index(index).expression
    @payslip = payslip
    @payslip_details = @payslip.payslip_details
    handle_expression_service = HandleExpressionService.new @payslip, @payslip_details
    result = handle_expression_service.calc_expression expression rescue nil
    result
  end
end
