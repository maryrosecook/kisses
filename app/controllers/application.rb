# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem # Be sure to include AuthenticationSystem in Application Controller instead

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '297cbf517751029fc33ceefd3543fbf2'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  # def capture_country
  #   # if !session[:country_id]
  #   #   country_str = Geolocating.get_user_country(request)
  #   #   begin
  #   #     country = Country.find_by_name(country_str)
  #   #     session[:country_id] = country.id
  #   #   rescue
  #   #     session[:country_id] = 1
  #   #   end
  #   # end
  # end
end
