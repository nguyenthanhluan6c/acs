class ExpressionService
  include ExpressionCheckTypes
  def initialize
    @regexs = {
      get_params_from_method: '([A-Z]+\()(.*)(\))',
      split_params_string_to_array: '[A-Z]+(?:\()[\(\)\w+\+\-\*\/\d+<=>\.\,\:\$%]+\)|[\w+\+\-\*\/\d+<=>\.\:\$%]+',
      find_operand: '[A-Z]+\d+:[A-Z]+\d+|[A-Z]+:[A-Z]+|\$[A-Z]+\$\d+|\$[A-Z]+|[A-Z]+\d+|[A-Z]+|\d+%|\d+\.\d+|\d+',
      operand_and_operator: '\$[A-Z]+\$\d+|\$[A-Z]+|[A-Z]+\d+|[A-Z]+|\d+%|\d+\.\d+|\d+|:|\+|\-|\*|\/|>=|<=|>|<|==|^|&&|,|\(|\)',
      operator: '\+|\-|\*|\/|>=|<=|>|<|==|\^|&&|:',
      parenthesis: '[()]',
      next_close_parenthesis: '(?:\))[\w\(]+'
    }
  end

  def valid_expression? expression
    if is_method? expression
      valid_parenthesis?(expression) && valid_syntax?(expression)
       # && valid_method?(expression)
    else
      valid_parenthesis?(expression) && valid_syntax?(expression)
    end
  end

  def valid_parenthesis? expression
    return false if expression =~ /#{@regexs[:next_close_parenthesis]}/
    parenthesis = expression.scan /#{@regexs[:parenthesis]}/
    parenthesis_stack = []
    parenthesis.each do |p|
      if p == "("
        parenthesis_stack.push p
      elsif parenthesis_stack.empty?
        return false
      else
        parenthesis_stack.pop
      end
    end
    parenthesis_stack.empty?
  end

  def valid_syntax? expression
    operand_and_operator = expression.scan /#{@regexs[:operand_and_operator]}/
    operand_and_operator.each_with_index do |element, index|
      if element =~ /\+|\-/
        return false if operand_and_operator[index + 1] !~ /#{@regexs[:find_operand]}/
      elsif element =~ /#{@regexs[:operator]}/
        if operand_and_operator[index - 1] !~ /#{@regexs[:find_operand]}/ || index <= 0 ||
          operand_and_operator[index + 1] !~ /#{@regexs[:find_operand]}/
          return false
        end
      end
    end
    return true
  end

  def valid_method? expresion_method
    method= expresion_method
    str_params = method.gsub /#{@regexs[:get_params_from_method]}/, "\\2"
    arr_params = str_params.scan /#{@regexs[:split_params_string_to_array]}/
    num_params = arr_params.count
    method_index = support_method method
    @errors = Settings.formulas.errors.not_suport unless method_index
    case method_index
    when "SUM("
      return num_params > 0
    when "ROUND("
      return num_params == 2
    when "IF("
      return num_params == 1
    end
    false
  end
end
