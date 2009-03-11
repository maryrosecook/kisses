module Maths
  
  VAGARIES = {"3" => "thousand", "6" => "million", "9" => "billion", "12" => "trillion"}
  
  def self.comma_format(str)
    str ? str.to_s.gsub(/(.)(?=.{3}+$)/, %q(\1,)) : nil
  end
  
  def self.vagarise(num)
    vaguest = num
   
    if vaguest
      for vagary in VAGARIES.keys().sort { |x,y| x.to_i <=> y.to_i }
        if num.to_s.length >= vagary.to_i
          if num.to_s.length == vagary.to_i
            vaguest = 1 + " " + VAGARIES[vagary]
          elsif 
        end
      end
    end

    return vaguest
  end
end