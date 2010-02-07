# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  
  before_filter :authenticate

  helper_method :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.record
  end

  def authenticate
    unless current_user
      flash[:notice] = "You must log in to access this page"
      redirect_to login_url
      return false
    end
  end

  def access_denied
    if current_user
      render :template => 'home/access_denied'
    else
      flash[:notice] = 'Access denied. Try to log in first.'
      redirect_to login_path
    end
  end
end
