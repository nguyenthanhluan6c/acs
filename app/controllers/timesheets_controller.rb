class TimesheetsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  def index
    @timesheets = Timesheet.includes_resources.all
  end

  def create
    if @timesheet.save
      flash[:success] = flash_message "created"
    end
    redirect_to :back
  end

  def update
    if @timesheet.update_attributes timesheet_params
      flash[:success] = flash_message "updated"
    end
    redirect_to :back
  end

  def destroy
    if @timesheet.destroy
      flash[:success] = flash_message "deleted"
    end
    redirect_to :back
  end

  private
  def timesheet_params
    params.require(:timesheet).permit Timesheet::ATTRIBUTES_PARAMS
  end
end
