class Admin::FormulasController < ApplicationController
  load_and_authorize_resource

  def index
    @formula = Formula.new
  end

  def create
    if @formula.save
      Employee.all.each do |employee|
        payslip = Payslip.find_or_create_by employee: employee, time: Date.current.beginning_of_month
        @formula.payslip_details.create payslip: payslip, detail_type: :formula
      end
      flash[:success] = flash_message "created"
    end
    redirect_to :back
  end

  def update
    if @formula.update_attributes formula_params
      flash[:success] = flash_message "updated"
    end
    redirect_to :back
  end

  def destroy
    if @formula.destroy
      flash[:success] = flash_message "deleted"
    end
    redirect_to :back
  end

  private
  def formula_params
    params.require(:formula).permit Formula::ATTRIBUTES_PARAMS
  end
end
