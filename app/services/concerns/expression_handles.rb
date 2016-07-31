module ExpressionHandles
  include ExpressionCheckTypes

  def handle_sum params
    params.reduce{|a, b| a.to_f + b.to_f}
  end

  def handle_round params
    number, count = params
    number.to_f.round count.to_i
  end

  def handle_if params
    test, then_value, otherwise_value = params
    test == false || test == 0 ? otherwise_value : then_value
  end

  def handle_method method
    if method_type = support_method(method)
      method_type = method_type.gsub("(","").downcase
      method = handle_setting method
      method_name = "handle_#{method_type}"
      arr_params = handle_params method
      begin
        send method_name, arr_params
      rescue
        raise I18n.t "formulas.errors.method_not_found", method_name: method_name
      end
    else
      @errors = Settings.formulas.errors.not_suport
      nil
    end
  end

  def handle_array array
    raise I18n.t "formulas.errors.array_not_found" unless is_array? array
    start_point, end_point = array.split ":"
    start_point = ConvertColumnService.index_char_to_int start_point
    end_point = ConvertColumnService.index_char_to_int end_point
    start_point..end_point
  end

  def handle_setting setting
    setting.gsub /#{@regexs[:setting]}/ do |st|
      Setting.find_by_index(ConvertColumnService.index_char_to_int(st
        .gsub(/#{@regexs[:replace_setting]}/, ""))).value
    end
  end

  def handle_column column
    table_expression = columns.detect do |column_record|
      column_record.index == column
    end.table_expression
    value_of table_expression
  end

  def handle_percent percent
    percent.gsub /#{@regexs[:percent]}/ do |pc|
      pc.gsub(/#{@regexs[:replace_percent]}/, "").to_f / 100
    end
  end

  def handle_params method
    str_params = method.gsub /#{@regexs[:get_params_from_method]}/, "\\2"
    arr_params = str_params.scan /#{@regexs[:split_params_string_to_array]}/
    calculated_params = []

    arr_params.each do |param|
      if is_array? param
        handle_array(param).each do |item_in_array_by_int|
          calculated_params.push handle_column ConvertColumnService
            .index_int_to_char item_in_array_by_int
        end
      else
        calculated_params.push calc_expression param
      end
    end
    calculated_params
  end
end
