class Unit < ActiveRecord::Base
  has_many :things
  belongs_to :category
  belongs_to :base_unit,
             :class_name => "Unit", 
             :foreign_key => "base_unit_id"
  
  def compatible_with?(unit)
    self.category == unit.category
  end
end