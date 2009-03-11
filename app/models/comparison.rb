class Comparison < ActiveRecord::Base
  belongs_to :first_thing,
             :class_name => "Thing", 
             :foreign_key => "first_thing_id"
  belongs_to :second_thing,
             :class_name => "Thing", 
             :foreign_key => "second_thing_id"
             
  VISIBLE = 1
  NON_VISIBLE = 0

  def self.new_(first_thing, second_thing, visible)
    comparison = self.new()
    comparison.first_thing = first_thing
    comparison.second_thing = second_thing
    comparison.visible = visible
    return comparison
  end


  def self.remove_non_visible(main_thing, things)
    non_visible_things = find_thing_comparisons(main_thing, things, NON_VISIBLE)
    non_visible_things.each { |no_show_thing| things.delete(no_show_thing) }
    return things
  end

  def self.find_thing_comparisons(main_thing, things, visible)
    comparisons = []
    for thing in things
      comparisons << thing if find_one_way_comparison(main_thing, thing, visible)
      comparisons << thing if find_one_way_comparison(thing, main_thing, visible)
    end
    
    return comparisons
  end
  
  def self.find_one_way_comparison(first_thing, second_thing, visible)
    where = "first_thing_id = #{first_thing.id} && second_thing_id = #{second_thing.id}"
    where += "&& visible = #{visible}" if visible
    self.find(:first, :conditions => where)
  end
  
  def self.find_comparison(first_thing, second_thing)
    comparison = find_one_way_comparison(first_thing, second_thing, nil)
    comparison = find_one_way_comparison(second_thing, first_thing, nil) if !comparison
    return comparison
  end
end