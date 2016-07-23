class ConvertColumnService
  AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  REPLACE_COLUMN = '([A-Z]+)(\d+)'
  class << self
    def index_int_to_char number
      str = ConvertColumnService::AZ
      if number < str.length
        str[number]
      else
        index_int_to_char((number / str.length).to_i - 1) +
          str[number % str.length]
      end
    end

    def index_char_to_int char
      str = ConvertColumnService::AZ
      char.gsub! /#{REPLACE_COLUMN}/, "\\1"
      if char.length > 1
        (str.index(char[-1])) + (index_char_to_int(char[0..-2]) + 1) * str.length
      else
        str.index char[0]
      end
    end
  end
end
