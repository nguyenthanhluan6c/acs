class Admin::ColumnsController < ApplicationController
  load_and_authorize_resource

  def index
    @column = Column.new
  end

  def create
    if @column.save
      flash[:success] = flash_message "created"
    end
    redirect_to :back
  end

  def update
    if @column.update_attributes column_params
      flash[:success] = flash_message "updated"
    end
    redirect_to :back
  end

  def destroy
    if @column.destroy
      flash[:success] = flash_message "deleted"
    end
    redirect_to :back
  end

  private
  def column_params
    params.require(:column).permit Column::ATTRIBUTES_PARAMS
  end
end
