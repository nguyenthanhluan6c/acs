class Admin::AdminSettingsController < ApplicationController
  load_and_authorize_resource

  def index
    @admin_setting = AdminSetting.new
  end

  def create
    if @admin_setting.save
      flash[:success] = flash_message "created"
    end
    redirect_to :back
  end

  def update
    if @admin_setting.update_attributes admin_setting_params
      flash[:success] = flash_message "updated"
    end
    redirect_to :back
  end

  def destroy
    if @admin_setting.destroy
      flash[:success] = flash_message "deleted"
    end
    redirect_to :back
  end

  private
  def admin_setting_params
    params.require(:admin_setting).permit AdminSetting::ATTRIBUTES_PARAMS
  end
end
