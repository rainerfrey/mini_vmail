class DomainsController < ApplicationController
  respond_to :html,:xml,:json
  
  def index
    @domains = Domain.all
    respond_with @domains
  end
  
  def show
    @domain = Domain.find(params[:id])
    respond_with @domain
  end
  
  def new
    @domain = Domain.new
    respond_with @domain
  end
  
  def create
    @domain = Domain.new(params[:domain])
    flash[:notice] = "Successfully created domain." if @domain.save
    respond_with @domain  
  end
  
  def edit
    @domain = Domain.find(params[:id])
    respond_with @domain
  end
  
  def update
    @domain = Domain.find(params[:id])
    flash[:notice] = "Successfully updated domain." if @domain.update_attributes(params[:domain])
    respond_with @domain  
  end
  
  def destroy
    @domain = Domain.find(params[:id])
    @domain.destroy
    flash[:notice] = "Successfully destroyed domain."
    respond_with @domain
  end
end
