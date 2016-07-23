module ExpressionCheckTypes
  ATOM_ELEMENTS = '\w+|\(|\)|\+|\-|\*|\/|<=|>=|==|,'
  METHODS_SUPPORTED = ["SUM(", "ROUND(", "IF("]
  def is_method? method
    atom_elements  = method.scan /#{ATOM_ELEMENTS}/
    stack_element = []
    atom_elements.each_with_index do |element, index|
      stack_element.push element if element == "("
      if element == ")"
        stack_element.pop
        return true if stack_element.empty? && atom_elements[index + 1].nil?
        return false if stack_element.empty? && atom_elements[index + 1].present?
      end
    end
    return false
  end

  def support_method? string
    priority_index = string.length
    method_index = nil
    METHODS_SUPPORTED.each_with_index do |method, index|
      current_method = string.index method
      if current_method && current_method < priority_index
        method_index = index
        priority_index = current_method
      end
    end
    method_index ? method_index : false
  end

  ["array", "column", "setting", "percent"].each do |type|
    define_method "is_#{type}?" do |string|
      /#{@regexs[type.to_sym]}/ =~ string.to_s
    end
  end
end
