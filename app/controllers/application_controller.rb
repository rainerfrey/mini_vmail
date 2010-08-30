class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  before_filter :locale_workaround
  
  helper_method :current_user

  private
  def set_select_domains
    @domains = Domain.active
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    request_auth unless current_user
  end
  
  def require_admin
    request_auth and return unless current_user
    unauthorized unless current_user.admin    
  end
  
  def request_auth
    respond_to do |format|
      format.html {redirect_to login_path}
      format.any(:json, :xml) {request_http_basic_authentication}
    end    
  end
  
  def unauthorized
    respond_to do |format|
      format.html do
        flash[:error]=t(:'messages.adminrequired')
        redirect_to login_path
      end
      format.any(:json, :xml) do
        render :text=> t(:'messages.adminrequired'), :status => :forbidden
      end
    end        
  end
  
  def set_modificator(model, method=action_name, user=current_user)
    model.send("#{method}d_by=", user.login) if user
  end
  
  def locale_workaround
    I18n.locale = I18n.default_locale if Rails.env == :production
  end
end
