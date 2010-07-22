class WelcomeController < ApplicationController
  def index
    if User.first.blank?
      flash[:notice] = I18n.t(:'messages.welcome.initial_login') 
      redirect_to :action => :initial_login and return
    end
    redirect_to login_path unless current_user
  end

  def initial_login
    unless User.first.blank?
      flash[:notice] = I18n.t(:'messages.welcome.initial_login_exists') 
      redirect_to root_path and return
    end
    @user = User.new do |u|
      u.login=I18n.t(:'administrator.defaults.login')
      u.notes=I18n.t(:'administrator.defaults.notes')
    end
  end

  def create_initial_login
    unless User.first.blank?
      flash[:notice] = I18n.t(:'messages.welcome.initial_login_exists') 
      redirect_to root_path and return
    end
    @user=User.new(params[:user])
    @user.admin=true
    if @user.save
      flash[:notice] = I18n.t(:'messages.welcome.initial_login_created')
      redirect_to users_path
    else
      render :action => :initial_login
    end
  end

end
