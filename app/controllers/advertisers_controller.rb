class AdvertisersController < ApplicationController
  def index
    @publisher = Publisher.find(params[:publisher_id])
    @advertisers = @publisher.advertisers
  end

  def new
    @advertiser = Advertiser.new
    @publisher = Publisher.find(params[:publisher_id])
  end

  def edit
    @advertiser = Advertiser.find(params[:id])
  end

  def create
    @advertiser = Advertiser.new(params[:advertiser],:publisher_id => params[:publisher_id])

    if @advertiser.save
      flash[:notice] = 'Advertiser was successfully created.'
      redirect_to edit_advertiser_path(@advertiser)
    else
      render action: "new"
    end
  end

  def update
    @advertiser = Advertiser.find(params[:id])

    if @advertiser.update_attributes(params[:advertiser])
       flash[:notice] = 'Advertiser was successfully updated.'
      redirect_to edit_advertiser_path(@advertiser)
    else
      render action: "edit"
    end
  end

  def destroy
    @advertiser = Advertiser.find(params[:id])
    @advertiser.destroy
    redirect_to publisher_advertisers_path(@advertiser.publisher)
  end
end
