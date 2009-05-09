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
  
  def self.value_with_symbol_and_commas(thing, country)
    category = thing.unit.category
    country_base_unit = country.base_unit(category)
    country_specific_value = thing.value_as(country_base_unit)
    unit = country.base_unit(category)
    
    value = country_base_unit.round(value).to_s
    
    if thing.value > 1
      value = comma_format(country_specific_value.to_i)
    else
      value = country_specific_value.to_s
    end
    
    
    value_with_symbol = unit.symbol + value if unit.symbol_before == 1
    value_with_symbol = value + unit.symbol if unit.symbol_before != 1
    return value_with_symbol
  end
  
  VOWELS = ["a", "e", "i", "o", "u", "h"]
  def self.indefinite_article(str)
    article = ""
    str = str.gsub(/\W/, "")
    VOWELS.include?(str.to_s[0..0].downcase) && !str.to_s[1..1].match(/[A-Z]/) ? article = "An" : article = "A" if str
    return article
  end
  
  def self.colour(i)
    return "colour_#{i % 7}"
  end
end