class PayslipsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @payslips = Payslip.of_month(Date.current).includes_resources
    @payslips.each do |payslip|
      payslip.update_cache_to_children
    end
    @formulas = Formula.of_payslips @payslips
  end
end
