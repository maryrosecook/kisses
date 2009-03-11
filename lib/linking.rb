module Linking
  
  def self.cookie_domain
    if production?
      return "kisses.com"
    else
      return "localhost"
    end
  end
  
  def self.production?
    ENV["RAILS_ENV"] == "production"
  end
end