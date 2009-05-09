class Country < ActiveRecord::Base
  has_and_belongs_to_many :units
  
  def base_unit(category)
    base_unit = nil
    if category = Category.find_by_identifier(category.identifier)
      base_unit = Unit.find_base_for_country_category(self, category)
    end
    
    return base_unit
  end
end