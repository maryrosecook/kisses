class ComparisonController < ApplicationController
  
  def edit_visibility
    if first_thing = Thing.find(params[:first_thing_id])
      if second_thing = Thing.find(params[:second_thing_id])
        if visible = params[:visible]
          if comparison = Comparison.find_comparison(first_thing, second_thing) # already recorded comparison
            comparison.visible = visible
          else
            comparison = Comparison.new_(first_thing, second_thing, visible)
          end
        
          #comparison.save()
        end
      end
    end
  end
end