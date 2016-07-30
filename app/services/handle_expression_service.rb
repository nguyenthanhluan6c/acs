class HandleExpressionService
  def initialize payslip, payslip_details
    # @payslip = payslip
    # @employee = payslip.employee
    # @payslip_details = payslip_details
    # @columns = Column.all
    @regexs = {
      array: '([A-Z]+\d+|[A-Z]+):([A-Z]+\d+|[A-Z]+)',
      column: '[A-Z]+\d+|[A-Z]+',
      replace_column: '([A-Z]+)(\d+)',
      setting: '\$[A-Z]+\$\d+|\$[A-Z]+',
      percent: '\d+%',
      replace_percent: '%',
      replace_setting: '\$|\d+',
      get_params_from_method: '([A-Z]+\()(.*)(\))',
      # split_params_string_to_array: '[A-Z]+(?:\()[\(\)\w+\+\-\*\/\d+<=>\.\,\:\$%]+\)|[\w+\+\-\*\/\d+<=>\.\:\$%]+',
      split_expression_with_method: '\w+\([^\)]+\)|[()+-\/*^]|%|,|>=|>|<=|<|!=|==|&&|\w+\(|\d+%|\d\.\d+|\d+|\w+',
      split_params_string_to_array: '[A-Z]+(?:\()[\(\)\w+\+\-\*\/\d+<=>\.\,\:\$%]+\)|[\w+\+\-\*\/\d+<=>\.\:\$%]+',
      find_space: '\s',
      find_operand: '[A-Z]+\d+:[A-Z]+\d+|[A-Z]+:[A-Z]+|\$[A-Z]+\$\d+|\$[A-Z]+|[A-Z]+\d+|[A-Z]+|\d+%|\d+\.\d+|\d+',
      # split_expression: '[A-Z]+(?:\()[\w+\:\(\+\*\/\-\)\>\=\<\!\,\$\%]+\)|[A-Z]+\:[A-Z]+|[A-Z]+\d+\:[A-Z]+\d+|'\
      #   '\$[A-Z]+\$\d+|\$[A-Z]+|[A-Z]+\d+|[A-Z]+|\d+%|\d+\.\d+|\d+|\^|\+|\-|\*|\/|>=|>|<=|<|!=|==|&&|[()]',
      split_expression: /[()+-\/*^]|%|,|>=|>|<=|<|!=|==|&&|\w+\(|\d+%|\d\.\d+|\d+|\w+/
    }
    @errors = nil
  end

  def calc_expression expression
    unless ExpressionService.new().valid_expression? expression
      @errors = Settings.formulas.errors.error_formula
    end

    expression = standardized_expression expression
    if is_method? expression
      elements = expression.scan /#{@regexs[:split_expression_with_method]}/
    else
      elements = expression.scan @regexs[:split_expression]
      return nil if elements.join != expression
      #replace ++ -- by +, -+ +- by -
    end
    puts elements
    sh = SupportExpression::Stack.new
    st = SupportExpression::Stack.new
    elements.each do |element|
      if /#{@regexs[:find_operand]}/ =~ element
        ["method", "setting", "column", "percent"].each do |type|
          if send("is_#{type}?", element)
            element = send "handle_#{type}", element
            break
          end
        end
        element = eval element if element.is_a? String
        puts element
        sh.push element
      elsif "(" == element
        st.push element
      elsif ")" == element
        x = st.pop
        while x != "("
          sh.push calc(sh.pop, sh.pop, x)
          x = st.pop
        end
      else
        while priority(element) <= priority(st.last)
          sh.push calc sh.pop, sh.pop, st.pop
        end
        st.push element
      end
    end

    while st.any?
      sh.push calc sh.pop, sh.pop, st.pop
    end
    sh[0]
  end

  def errors
    @errors
  end

  private
  include ExpressionCheckTypes
  include ExpressionHandles
  include SupportExpression
  def standardized_expression expression
    expression.gsub! /#{@regexs[:find_space]}/, ""
    expression.upcase!
    expression
  end

  def calc first_operand, second_operand, operator
    if ["+", "-", "*", "/", ">=", ">", "<", "<=", "^"].include? operator
      first_operand, second_operand = first_operand.to_f, second_operand.to_f
      raise ZeroDivisionError if operator == "/" && first_operand == 0
    elsif ["&&", "||"].include? operator
      first_operand, second_operand = !!first_operand, !!second_operand
    end

    eval "#{second_operand}#{operator}#{first_operand}"
  end

  def priority operator
    return 6 if operator == "^"
    return 5 if ["*", "/"].include? operator
    return 4 if ["+", "-"].include? operator
    return 3 if [">=", ">", "<", "<="].include? operator
    return 2 if ["==", "!="].include? operator
    return 1 if ["&&", "||"].include? operator
    return 0 if ["(", ")"].include? operator
    return -1
  end
end
