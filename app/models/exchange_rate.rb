class ExchangeRate < ActiveRecord::Base
  belongs_to :first_unit,
             :class_name => "Unit", 
             :foreign_key => "first_unit_id"
  belongs_to :second_unit,
             :class_name => "Unit", 
             :foreign_key => "second_unit_id"
             
  def self.find_for_units(first_unit, second_unit)
    self.find(:first, :conditions => "first_unit_id = #{first_unit.id} && second_unit_id = #{second_unit.id}")
  end
end