class Unit < ActiveRecord::Base
  has_many :things
  belongs_to :category
  belongs_to :base_unit,
             :class_name => "Unit", 
             :foreign_key => "base_unit_id"
  
  def appropriate_things(main_thing)
    appropriate_things = []
    for potential_thing in things()
      appropriate_things << potential_thing if potential_thing.value_as(self.base_unit) < main_thing.value_as(self.base_unit)
    end
    
    return appropriate_things
  end
  
  def compatible_with?(unit)
    self.category == unit.category
  end
end