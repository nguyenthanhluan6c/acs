class SalariesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :index
  def index
    @salaries = Salary.includes_categories.all
  end
end
