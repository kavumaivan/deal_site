# After carefull investigation of imput file, I had to introduce a , as a delimiter otherwise space was not usable as some fields had space in them.
# I will require comma(,) delimited csv format information in the future.
namespace :data do 
  desc "import data from daily_planet_export.txt to deals table" 
  task :import => :environment do 
    file = File.open("script/data/daily_planet_export.txt") 
    
   
    i = 0
    file.each do |line| 
      
      if i==0 then
         # do nothing just skipping the first line which is the header.
      else
      attrs = line.split(",") 
      deal = Deal.new 
      advertiser = Advertiser.find_by_name(attrs[0])
      publisher = Publisher.find_by_name("The Daily Planet")  
      
      if publisher == nil
         publisher = Publisher.create(:name => "The Daily Planet")
         publisher.save!
       end
       
       if advertiser == nil
         advertiser = Advertiser.create(:name => attrs[0],:publisher_id => publisher.id)
         advertiser.save!
       end
      dateregex = /\d{2}\/\d{2}\/\d{4}/ 
      deal.advertiser_id = advertiser.id
      deal.start_at = dateregex =~ attrs[1] ? attrs[1] : Time.now
      deal.end_at = dateregex =~ attrs[2] ? attrs[2] : Time.now
      deal.proposition = attrs[3]
      deal.price = attrs[4]
      deal.value = attrs[5]
      deal.description = attrs[3]
      deal.save! 
    end 
    
      i += 1
    end
  end 
end 
