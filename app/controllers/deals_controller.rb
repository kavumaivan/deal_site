require 'will_paginate/array'
require 'will_paginate/active_record'


class DealsController < ApplicationController
  before_filter :assign_deal, only: [ :show, :edit, :update, :destroy ]
  before_filter :set_view_paths, only: :show

  def index
     begin
      @search = params[:search]
  
      if @search != nil
          @deals = Deal.search(@search).paginate(:page => params[:page], :per_page => 10) 
       else
          @deals = Deal.paginate(:page => params[:page], :per_page => 10)
      end
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def show
    begin  
       @theme = @deal.advertiser.publisher.theme
      respond_to do |format|
        format.html { render layout: "deals/show" }
        format.json { render json: @deal }
      end
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def new
    begin
      @advertiser = Advertiser.all  #find(params[:advertiser_id])
      @deal = Deal.new #@advertiser.deals.build
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def create
    begin
      @deal = Deal.new(params[:deal])
      @advertiser = Advertiser.find(@deal.advertiser_id)
      @deal = @advertiser.deals.build(params[:deal])
      if @deal.save
        flash[:notice] = 'Deal was successfully created.'
        redirect_to deals_url
      else
        render action: "new"
      end
     rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to new_deals_url
    end
  end

  def update
    begin
      if @deal.update_attributes(params[:deal])
        flash[:notice] = 'Deal was successfully updated.'
        redirect_to deals_url
      else
        render action: "edit"
      end
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to edit_deals_url(@deal)
    end
  end

  def destroy
    begin
        @deal.destroy
        redirect_to deals_url
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end


  protected

  def assign_deal
    begin
       @deal = Deal.find(params[:id])
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def set_view_paths
    if (/^entertainment(.*)/).match(@deal.advertiser.publisher.theme)
       prepend_view_path "app/themes/entertainment/views"
    else
       prepend_view_path "app/themes/#{@deal.advertiser.publisher.theme}/views"
    end
  end
end
