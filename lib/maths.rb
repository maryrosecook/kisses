module Maths
  
  VAGARIES = {3 => "thousand", 6 => "million", 9 => "billion", 12 => "trillion"}
  
  def self.comma_format(str)
    str ? str.to_s.gsub(/(.)(?=.{3}+$)/, %q(\1,)) : nil
  end
  
  def self.vagarise(num)
    num = num.to_s
    vaguest = num
   
    if vaguest
      for vagary in VAGARIES.keys().sort { |x,y| x <=> y }
        if num.length >= vagary
          unit = num[0..2].to_f / (10 ** (3 - (num.length - vagary)))
          vaguest = unit.round().to_s + " " + VAGARIES[vagary]
        end
      end
    end

    return vaguest
  end
end