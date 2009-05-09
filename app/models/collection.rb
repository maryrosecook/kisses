class Collection < ActiveRecord::Base
  has_and_belongs_to_many :things
  
  def self.new_with_identifier(identifier)
    collection = self.new
    collection.identifier = identifier
    return collection
  end
  
  def ordered_things
    self.things.sort { |x,y| y.value <=> x.value }
  end
  
  def get_main_thing
    ordered_things[0]
  end
  
  def get_other_things
    other_things = ordered_things
    other_things.delete_at(0)
    return other_things
  end
end