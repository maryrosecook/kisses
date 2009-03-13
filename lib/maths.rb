module Maths
  
  VAGARIES = {4 => "thousand", 7 => "million", 10 => "billion", 13 => "trillion"}
  
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
end