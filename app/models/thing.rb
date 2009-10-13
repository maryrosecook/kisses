class Thing < ActiveRecord::Base
  belongs_to :unit
  has_and_belongs_to_many :collections
  
  def self.new_from_adding(body, unit_id, value)
    thing = nil
    if Util.ne(body) && Util.ne(unit_id) && Util.ne(value)
      thing = self.new()
      thing.body = body
      thing.unit_id = unit_id
      thing.value = value
      thing.generate_identifier()
    end
    
    return thing
  end
  
  def value_as(new_unit)
    converted_value = nil
    if self.unit.compatible_with?(new_unit)
      if self.unit != new_unit
        ratio = Unit.ratio(self.unit, new_unit)
        converted_value = self.value.to_f / ratio.to_f
      else
        converted_value = value
      end
    end

    converted_value = (converted_value.to_f * 100).round().to_f / 100
    return converted_value
  end
  
  def multiple(other_thing)
    self.value != 0 ? (other_thing.value_as(self.unit).to_f / self.value.to_f).round() : 0
  end
  
  def inflected_body(count)
    inflected_body = self.body
    if count != 1    
      words = self.body.split(" ")
      noun = words[words.length-1]
      noun_i = words.length-1
      
      i = 0
      for word in words
        if word.match(/\([^\)]*\)/)
          noun = word
          noun_i = i
        end
        i += 1
      end
      
      inflected_noun = noun.pluralize
      inflected_body_start = ""
      inflected_body_start = words[0..noun_i-1].join(" ") if noun_i > 0
      inflected_body_end = words[noun_i+1..words.length-1].join(" ")      
      inflected_body = inflected_body_start + " " + inflected_noun + " " + inflected_body_end
    end
    
    inflected_body = inflected_body.gsub(/\(/, "").gsub(/\)/, "") 
    
    return inflected_body
  end
  
  def self.fill_in_identifiers
    self.find(:all).each { |thing| thing.generate_identifier() }
  end
  
  def generate_identifier
    if !self.identifier && self.body
      identifier = self.body.downcase().gsub(/\W/, "")
      identifier_try = identifier

      i = 1
      while Thing.find_by_identifier(identifier_try)
        identifier_try = identifier + i.to_s
        i += 1
      end

      self.identifier = identifier_try
    end
    
    self.save()
  end
  
  def self.find_sanctioned
    self.find(:all, :conditions => "sanctioned = 1")
  end
end