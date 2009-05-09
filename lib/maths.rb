module Maths
  
  VAGARIES = { 4 => "thousand", 7 => "million", 10 => "billion", 13 => "trillion", 16 => "quadrillion", 19 => "quintillion", 22 => "sextillion", 25 => "septillion" }
  
  def self.vagarise(num)
    num = num.to_s
    vaguest = num
   
    if Configuring.get("vagaries_on")
      for vagary in VAGARIES.keys().sort { |x,y| x <=> y }
        if num.length >= vagary
          unit = num[0..2].to_f / (10 ** (2 - (num.length - vagary)))
          vaguest = unit.round().to_s + " " + VAGARIES[vagary]
        end
      end
    end

    return vaguest
  end
  
  def self.round_to(num, x)
    rounded_num = (num * 10**x).round.to_f / 10**x
    if x > 0
      if !rounded_num.to_s.match(/\.\d+/)
        rounded_num = rounded_num.to_s + "." + ("0" * x)
      end
    else
      rounded_num = rounded_num.to_i
    end
    
    return rounded_num
  end
end