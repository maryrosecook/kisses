class CategoryController < ApplicationController


  def show
    @categories = Category.find(:all)

    @main_thing = nil
    @other_things = []
    if category = Category.find_by_identifier(params[:identifier])
      for category_unit in category.units()
        @other_things += category_unit.things()
      end
    
      @main_thing = @other_things.pop if @other_things.length > 1 # got a thing and at least one other_thing
    end
  end
end