module Form
  
  def self.f_date(date)
    date.strftime("%d.%m.%y") if date
  end
  
  def self.f_date_time(date)
    date.strftime("%d.%m.%y %H:%M") if date
  end
  
  def self.comma_format(str)
    str ? str.to_s.gsub(/(.)(?=.{3}+$)/, %q(\1,)) : nil
  end
  
  def self.value_with_symbol_and_commas(thing)
    unit = thing.unit
    if thing.value > 1
      value = comma_format(thing.value.to_i)
    else
      value = thing.value.to_s
    end
    
    value_with_symbol = unit.symbol + value if unit.symbol_before
    value_with_symbol = value + unit.symbol if !unit.symbol_before
    return value_with_symbol
  end
  
  VOWELS = ["a", "e", "i", "o", "u"]
  def self.indefinite_article(str)
    indefinite_article = ""
    VOWELS.include?(str.to_s[0..0].downcase) ? indefinite_article = "An" : indefinite_article = "A" if str
    return indefinite_article
  end
  
  def self.colour(i)
    return "colour_#{i % 5}"
  end
end