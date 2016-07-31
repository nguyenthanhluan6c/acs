class Formula < ApplicationRecord
  def excute_value payslip_caculation_service
    payslip_caculation_service.calc_expression expression rescue nil
  end
end
