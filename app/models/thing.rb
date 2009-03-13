class Thing < ActiveRecord::Base
  belongs_to :unit
  
  def value_as(new_unit)
    converted_value = nil
    if self.unit.compatible_with?(new_unit)
      if self.unit != new_unit
        ratio = self.unit.base_unit_ratio.to_f / new_unit.base_unit_ratio.to_f
        converted_value = self.value.to_f / ratio.to_f
      else
        converted_value = value
      end
    end
    
    return converted_value
  end
  
  def multiple(other_thing)
    return (other_thing.value_as(self.unit).to_f / self.value.to_f).round()
  end
  
  def inflected_body(count)
    inflected_body = self.body
    if count != 1    
      words = self.body.split(" ")
      noun = words[words.length-1]
      inflected_noun = noun.pluralize
      inflected_body = words[0..words.length-2].join(" ") + " " + inflected_noun
    end
    
    return inflected_body
  end
  
  
  def self.fill_in_identifiers
    for thing in self.find(:all)
      if !thing.identifier
        thing.identifier = thing.body.gsub(/\W/, "").downcase
        thing.save()
      end
    end
  end
end