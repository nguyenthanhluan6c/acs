class SalariesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  def index
    @salaries = Salary.includes_categories.all
  end

  def update
    if @salary.update_attributes salary_params
      flash[:success] = flash_message "updated"
    end
    redirect_to :back
  end

  def destroy
    if @salary.destroy
      flash[:success] = flash_message "deleted"
    end
    redirect_to :back
  end

  private
  def salary_params
    params.require(:salary).permit Salary::ATTRIBUTES_PARAMS
  end
end
