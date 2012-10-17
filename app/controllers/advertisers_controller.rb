class AdvertisersController < ApplicationController
  def index
    begin
        @publisher = Publisher.find(params[:publisher_id])
        @advertisers = @publisher.advertisers
        
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def new
    begin
        @advertiser = Advertiser.new
        @publisher = Publisher.find(params[:publisher_id])
        
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def edit
    begin
        @advertiser = Advertiser.find(params[:id])
        
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def create
    begin
          @advertiser = Advertiser.new(params[:advertiser],:publisher_id => params[:publisher_id])
      
          if @advertiser.save
            flash[:notice] = 'Advertiser was successfully created.'
            redirect_to edit_advertiser_path(@advertiser)
          else
            render action: "new"
          end
       
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to new_advertisers_path(@advertiser)
    end
  end

  def update
    begin
          @advertiser = Advertiser.find(params[:id])
      
          if @advertiser.update_attributes(params[:advertiser])
             flash[:notice] = 'Advertiser was successfully updated.'
            redirect_to edit_advertiser_path(@advertiser)
          else
            render action: "edit"
          end
      
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to edit_advertisers_path(@advertiser)
    end
  end

  def destroy
    begin
          @advertiser = Advertiser.find(params[:id])
          @advertiser.destroy
          redirect_to publisher_advertisers_path(@advertiser.publisher)
    
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end
end
