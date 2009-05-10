class HomeController < ApplicationController

  def index
    @collections = Collection.find(:all)
  end
  
  def run
    
  end
end