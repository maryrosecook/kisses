class HomeController < ApplicationController

  def index
    @collections = Collection.find_sanctioned()
    @things = Thing.find_sanctioned()
  end
  
  def run
    
  end
end