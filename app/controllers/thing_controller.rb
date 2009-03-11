class ThingController < ApplicationController

  def show
    @main_thing = Thing.find(params[:id])
    @other_things = []
    if category = @main_thing.unit.category
      category.units().each { |category_unit| @other_things += category_unit.things() }
      @other_things.delete(@main_thing) if @other_things.include?(@main_thing)
      @other_things = Comparison.remove_non_visible(@main_thing, @other_things)
      @other_things = @other_things.sort { |x,y| x.multiple(@main_thing) <=> y.multiple(@main_thing) }
    end
  end
end