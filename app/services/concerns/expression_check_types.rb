module ExpressionCheckTypes
  ATOM_ELEMENTS = '\w+|\(|\)|\+|\-|\*|\/|<=|>=|==|,'
  METHODS_SUPPORTED = ["SUM(", "ROUND(", "IF("]
  def is_method? method
    # atom_elements  = method.scan /#{ATOM_ELEMENTS}/
    # stack_element = []
    # atom_elements.each_with_index do |element, index|
    #   if element == "("
    #     stack_element.push element 
    #   elsif element == ")"
    #     stack_element.pop
    #     binding.pry
    #     return true if stack_element.empty? && atom_elements[index + 1].nil?
    #     return false if stack_element.empty? && atom_elements[index + 1].present?
    #   end
    # end
    # return false
    support_method(method).present?
  end

  def support_method string
    METHODS_SUPPORTED.each_with_index do |method, index|
      current_method = string.index method
      return method if current_method.present?
    end
    nil
  end

  ["expression_index", "array", "column", "setting", "percent"].each do |type|
    define_method "is_#{type}?" do |string|
      /#{@regexs[type.to_sym]}/ =~ string.to_s
    end
  end
end
