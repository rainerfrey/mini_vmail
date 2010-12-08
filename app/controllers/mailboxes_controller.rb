require 'pagination_responder'

class MailboxesController < ApplicationController
  respond_to :html,:xml,:json
  before_filter :require_user
  before_filter :set_select_domains, :only => [:new, :create, :edit, :update, :index]
  
  def index
    @mailboxes = Mailbox.search(params)
    respond_with @mailboxes, :responder => PaginationResponder
  end
  
  def show
    @mailbox = Mailbox.find(params[:id])
    respond_with @mailbox
  end
  
  def new
    @mailbox = Mailbox.new
    @mailbox.active = true
    serialize_opts = {:only => [:name, :domain_id, :active,:notes], :methods=>[:my_password,:my_password_confirmation]} 
    respond_with @mailbox do |format|
      format.json { render :json => @mailbox.as_json(serialize_opts)}
      format.xml { render :xml => @mailbox.to_xml(serialize_opts)}
    end
  end
  
  def create
    @mailbox = Mailbox.new(params[:mailbox])
    set_modificator @mailbox
    flash[:notice] = I18n.t(:'resource.created', :model=> Mailbox.model_name.human) if @mailbox.save
    respond_with @mailbox
   end
  
  def edit
    @mailbox = Mailbox.find(params[:id])
    respond_with @mailbox
  end
  
  def update
    @mailbox = Mailbox.find(params[:id])
    set_modificator @mailbox
    flash[:notice] = I18n.t(:'resource.updated', :model=> Mailbox.model_name.human) if @mailbox.update_attributes(params[:mailbox])
    respond_with @mailbox
  end
  
  def destroy
    @mailbox = Mailbox.find(params[:id])
    @mailbox.destroy
    flash[:notice] = I18n.t(:'resource.destroyed', :model=> Mailbox.model_name.human)
    respond_with @mailbox
  end
  
end
