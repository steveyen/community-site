# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  caches_page :index

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '289fc1f90353427ae6f923d52900a500'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  caches_page :index
 
  def initialize
    @page_title = 'memcached'
  end
 
  protected
 
  def title(t)
    @page_title = t
  end
 
  def subtitle(t)
    title "#{t} -- stops website death"
  end
end
