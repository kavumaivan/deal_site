require 'will_paginate/array'
require 'will_paginate/active_record'


class DealsController < ApplicationController
  before_filter :assign_deal, only: [ :show, :edit, :update, :destroy ]
  before_filter :set_view_paths, only: :show

  def index
     
      @search = params[:search]
  
    if @search != nil
        @deals = Deal.where("Proposition Like ? OR Value Like ? OR Price Like ? OR Description LIKE ? ","%#{@search}%","%#{@search}%","%#{@search}%","%#{@search}%").paginate(:page => params[:page], :per_page => 10) 
     else
        @deals = Deal.paginate(:page => params[:page], :per_page => 10) 
    end
 
  end

  def show
     @theme = @deal.advertiser.publisher.theme
    respond_to do |format|
      format.html { render layout: "deals/show" }
      format.json { render json: @deal }
    end
  end

  def new
    @advertiser = Advertiser.all  #find(params[:advertiser_id])
    @deal = Deal.new #@advertiser.deals.build
  end

  def create

    @deal = Deal.new(params[:deal])
    @advertiser = Advertiser.find(@deal.advertiser_id)
    @deal = @advertiser.deals.build(params[:deal])
    if @deal.save
      flash[:notice] = 'Deal was successfully created.'
      redirect_to deals_url
    else
      render action: "new"
    end
  end

  def update
    if @deal.update_attributes(params[:deal])
      flash[:notice] = 'Deal was successfully updated.'
      redirect_to deals_url
    else
      render action: "edit"
    end
  end

  def destroy
    @deal.destroy
    redirect_to deals_url
  end


  protected

  def assign_deal
    @deal = Deal.find(params[:id])
  end

  def set_view_paths
    if (/^entertainment(.*)/).match(@deal.advertiser.publisher.theme)
       prepend_view_path "app/themes/entertainment/views"
    else
       prepend_view_path "app/themes/#{@deal.advertiser.publisher.theme}/views"
    end
  end
end
