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
  
  def factor(other_thing)
    return (other_thing.value_as(self.unit).to_f / self.value.to_f).to_f
  end
end