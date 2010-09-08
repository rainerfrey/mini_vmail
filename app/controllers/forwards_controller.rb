class ForwardsController < ApplicationController
  respond_to :html,:xml,:json
  before_filter :require_user
  before_filter :set_select_domains, :only => [:new, :create, :edit, :update]

  def index
    @forwards = Forward.includes(:domain).ordered
    respond_with @forwards
  end
  
  def show
    @forward = Forward.find(params[:id])
    respond_with @forward
  end
  
  def new
    @forward = Forward.new
    respond_with @forward
  end
  
  def create
    @forward = Forward.new(params[:forward])
    set_modificator @forward
    flash[:notice] = I18n.t(:'resource.created', :model=> Forward.model_name.human) if @forward.save
    respond_with @forward
  end
  
  def edit
    @forward = Forward.find(params[:id])
    respond_with @forward
  end
  
  def update
    @forward = Forward.find(params[:id])
    set_modificator @forward
    flash[:notice] = I18n.t(:'resource.updated', :model=> Forward.model_name.human) if @forward.update_attributes(params[:forward])
    respond_with @forward
  end
  
  def destroy
    @forward = Forward.find(params[:id])
    @forward.destroy
    flash[:notice] = I18n.t(:'resource.destroyed', :model=> Forward.model_name.human)
    respond_with @forward
  end
end
