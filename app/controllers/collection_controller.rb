class CollectionController < ApplicationController
  auto_complete_for :thing, :body
  skip_before_filter :verify_authenticity_token
  
  def show
    @country = Country.find(session[:country_id])
    collection = Collection.find_by_identifier(params[:identifier])
    @main_thing = collection.get_main_thing()
    @other_things = collection.get_other_things()
  end
  
  def new
    if request.post?
      collection = Collection.new_with_identifier(params[:collection][:identifier])
      collection.save
      redirect_to("/collection/edit/" + collection.identifier)
    else
      @collection = Collection.new
    end
  end
  
  def add_thing
    collection = Collection.find(params[:id])
    @thing = Thing.find_by_body(params[:thing][:body])
    collection.things << @thing if !collection.things.include?(@thing)
    collection.save()
  end
  
  def edit
    @collection = Collection.find_by_identifier(params[:identifier])
  end
end