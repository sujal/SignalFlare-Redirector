class SgnlParser

  INDEX_LIST = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','~','*','_','.','!','\'','(',')']

  def encoded_latlng(val)

    unless val.nil?
      raw_input = val 
      if raw_input.is_a? String

        raw_input = val.to_f

      end

      decimal_input = (raw_input*1000000).round

      self.encoded_int(decimal_input)

    end
    
  end
  def encoded_int(val)
    base = INDEX_LIST.size
    neg = false
    piece = val
    if piece.is_a? String
      piece = piece.to_i 
    end
    if piece < 0
      neg = true
      piece = piece.abs
    end
    output = ""
    until piece == 0
      output = INDEX_LIST[piece % 70] + output
      piece = (piece/base).round
    end

    if neg
      output = "-" << output
    end

    output

  end

  def encoded_latlng(val)
    floated_val = val.to_f
    adjusted_val = (floated_val*1000000).round
    self.encoded_int(adjusted_val)
  end

  def decode_latlng(val)

    clean_val = nil
    neg = false

    if val[0] == "-"
      clean_val = val[1..-1]
      neg = true
    else
      clean_val = val
    end

    cur_index = clean_val.size-1

    raw_decimal = 0

    clean_val.each_codepoint do |c|

      adjusted_point = 0

      case c
      when 48..57
        adjusted_point = c-48
      when 97..122
        adjusted_point = c-87
      when 65..90
        adjusted_point = c-29
      when 126
        adjusted_point = 62
      when 42
        adjusted_point = 63
      when 95
        adjusted_point = 64
      when 46
        adjusted_point = 65
      when 33
        adjusted_point = 66
      when 39
        adjusted_point = 67
      when 40..41
        adjusted_point = c+28
      end

      raw_decimal += adjusted_point*(70**cur_index)

      cur_index -= 1
      
    end

    if neg
      raw_decimal = raw_decimal*-1
    end

    raw_decimal / 1000000.0
    
  end


end
