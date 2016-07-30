module SupportExpression
  class Stack < Array
    def push value
      super
    end
    alias_method :"<<", :push

    def pop
      raise "Stack is empty" if is_empty?
      super
    end

    def is_empty?
      empty?
    end
  end
end
