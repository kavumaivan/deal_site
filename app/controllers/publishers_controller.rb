class PublishersController < ApplicationController
  def index
    begin
        @publishers = Publisher.all
        
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to :root
    end
  end

  def new
    begin
        @publisher = Publisher.new(params[:publisher])
        render :edit
     
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to edit_publisher_path(@publisher)
    end
  end

  def create
    begin
        @publisher = Publisher.new(params[:publisher])
    
        if @publisher.save
          flash[:notice] = 'Publisher was successfully created.'
          redirect_to edit_publisher_path(@publisher)
        else
          render action: "new"
        end
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to new_publisher_path
    end
  end

  def edit
    begin
           @publisher = Publisher.find(params[:id])
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to  show_publisher_path(@publisher)
    end
  end

  def update
    begin
          @publisher = Publisher.find(params[:id])
          if @publisher.update_attributes(params[:publisher])
            flash[:notice] = "Updated #{@publisher.name}"
            redirect_to edit_publisher_path(@publisher)
          else
            render :edit
          end
    rescue Exception => e  
        logger.error e.message
        flash[:warn] = e.message 
        redirect_to  edit_publisher_path(@publisher)
    end
  end
end
