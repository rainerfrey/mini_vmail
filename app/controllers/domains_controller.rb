class DomainsController < ApplicationController
  respond_to :html,:xml,:json
  before_filter :require_user
  
  def index
    @domains = Domain.ordered
    respond_with @domains
  end
  
  def show
    @domain = Domain.find(params[:id])
    respond_with @domain
  end
  
  def new
    @domain = Domain.new
    @domain.transport = APP_CONFIG[:relay_transport]
    respond_with @domain
  end
  
  def create
    @domain = Domain.new(params[:domain])
    set_modificator @domain
    flash[:notice] = I18n.t(:'resource.created', :model=> Domain.model_name.human) if @domain.save
    respond_with @domain  
  end
  
  def edit
    @domain = Domain.find(params[:id])
    respond_with @domain
  end
  
  def update
    @domain = Domain.find(params[:id])
    set_modificator @domain
    flash[:notice] = I18n.t(:'resource.updated', :model=> Domain.model_name.human) if @domain.update_attributes(params[:domain])
    respond_with @domain  
  end
  
  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy
    flash[:notice] = I18n.t(:'resource.destroyed', :model=> Domain.model_name.human)
    respond_with @domain
  end
end
