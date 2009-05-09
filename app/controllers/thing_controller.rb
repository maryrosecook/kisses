class ThingController < ApplicationController
  before_filter :capture_country
  
  def show
    @country = Country.find(session[:country_id])
    @main_thing = Thing.find_by_identifier(params[:identifier])
    @other_things = []
    if category = @main_thing.unit.category
      category.units().each { |category_unit| @other_things += category_unit.appropriate_things(@main_thing) }
      @other_things.delete(@main_thing) if @other_things.include?(@main_thing)
      @other_things = @other_things.sort { |x,y| y.value_as(y.unit) <=> x.value_as(x.unit) }
    end
  end
end