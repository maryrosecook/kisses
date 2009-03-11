class Comparison < ActiveRecord::Base
  belongs_to :first_thing,
             :class_name => "Thing", 
             :foreign_key => "first_thing_id"
  belongs_to :second_thing,
             :class_name => "Thing", 
             :foreign_key => "second_thing_id"
             
  VISIBLE = 1
  NON_VISIBLE = 0


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
    self.find(:first, :conditions => "visible = #{visible} && first_thing_id = #{first_thing.id} && second_thing_id = #{second_thing.id}")
  end
end