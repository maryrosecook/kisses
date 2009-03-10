class HomeController < ApplicationController

  def index
    @categories = Category.find(:all)
  end
end