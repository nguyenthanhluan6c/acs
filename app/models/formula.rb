class Formula < ApplicationRecord
  def excute_value
    HandleExpressionService.new(nil,nil).calc_expression expression rescue nil
  end
end
