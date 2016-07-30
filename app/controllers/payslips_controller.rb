class PayslipsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index

  def index
    @payslips = Payslip.of_month(Date.current).includes_resources
    @formulas = Formula.all
  end
end
