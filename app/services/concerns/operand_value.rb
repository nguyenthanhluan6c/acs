module OperandValue
  AVALIABLE_TABLES = ["admin_settings", "employees", "levels", "benefits",
    "timesheets", "overtimes", "overtime_details"].map{|x| x.classify.safe_constantize}
  DATABAE_EXPRESSION_REGEX = /\A\w{1,}[.]\w{1,},?\w{1,}[:]\w{1,}\Z/
  #EXAMPLE = "admin_setting.value,name:health_allowance"
  class << self
    def value_of params
      str = params.to_s
      return Float str if numeric? str
      return value_of_database_expression str if valid_database_expression? str
    end

    private
    def numeric? str
      Float(str) != nil rescue false
    end

    def valid_database_expression? str
      !!(str =~ DATABAE_EXPRESSION_REGEX)
    end

    def value_of_database_expression str
      table_name, table_column, attribute, value = str.split /\W/
      table = table_name.classify.safe_constantize
      return nil unless table.in? AVALIABLE_TABLES
      params = Hash[attribute, value]
      result = table.where(params).first.read_attribute table_column.to_sym rescue nil
    end
  end
end
