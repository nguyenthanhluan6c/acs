module OperandValue
  AVALIABLE_TABLES = ["admin_settings", "employees", "levels", "benefits",
    "timesheets", "overtimes", "overtime_details"].map{|x| x.classify.safe_constantize}
  DATABAE_EXPRESSION_REGEX = /\A\w{1,}[.]\w{1,},?\w{1,}[:]\w{1,}\Z/
  #EXAMPLE = "admin_setting.value,name:health_allowance"

  def value_of params
    str = params.to_s.gsub /\s+/, ""
    return Float str if OperandValue.numeric? str
    return value_of_database_expression str if OperandValue.valid_database_expression? str
  end

  private
    def value_of_database_expression str
    puts "accessing table"
    table_name, table_column, attribute, value = str.split /\W/
    table = table_name.classify.safe_constantize
    return nil unless table.in? AVALIABLE_TABLES
    case table_name
    when "admin_settings"
      params = Hash[attribute, value]
      result = table.where(params).first.read_attribute table_column.to_sym rescue nil
    when "benefits"
      result = table.where(employee: @employee).first.read_attribute table_column.to_sym rescue nil
    when "levels"
      result = table.includes(:allowance_details).where(allowance_details: {employee: @employee}).
        order(level: :desc).first.read_attribute table_column.to_sym rescue nil
    else
      nil
    end
  end

  class << self
    def numeric? str
      Float(str) != nil rescue false
    end

    def valid_database_expression? str
      !!(str =~ DATABAE_EXPRESSION_REGEX)
    end
  end
end
