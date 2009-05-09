class Unit < ActiveRecord::Base
  has_many :things
  belongs_to :category
  belongs_to :base_unit,
             :class_name => "Unit", 
             :foreign_key => "base_unit_id"
  has_and_belongs_to_many :countries
  
  def self.find_base_for_country_category(country, category)
    base_unit = nil
    country.units().each { |unit| base_unit = unit if unit.category == category && unit.base_unit == unit }
    return base_unit
  end
  
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
  
  def self.ratio(unit_1, unit_2)
    ratio = nil
    if unit_1.compatible_with?(unit_2)
      if unit_1.category == Category.find_by_identifier(Category::MONEY)
        if exchange_rate = ExchangeRate.find_for_units(unit_1, unit_2)
          ratio = exchange_rate.rate
        end
      else
        ratio = unit_1.base_unit_ratio.to_f / unit_2.base_unit_ratio.to_f
      end
    end
    
    return ratio
  end
  
  def round(num)
    rounded_num = num.to_f
    if self.category.identifier == Category::MONEY
      if rounded_num > 1
        rounded_num = Maths.round_to(rounded_num, 0)
      else
        rounded_num = Maths.round_to(rounded_num, 2)
      end
    end
    
    return rounded_num
  end
end