class Deal < ActiveRecord::Base
  belongs_to :advertiser

  validates_presence_of :advertiser, :value, :price, :description, :start_at, :end_at

  def over?
    Time.zone.now > end_at
  end

  def savings_as_percentage
    0.5
  end

  def savings
    20
  end
  
  def self.search(value)
    self.where("Proposition Like ? OR Value Like ? OR Price Like ? OR Description LIKE ? OR advertiser_id IN (SELECT id FROM advertisers WHERE NAME like ? OR publisher_id IN (SELECT id FROM publishers WHERE name LIKE ?)) ","%#{value}","%#{value}%","%#{value}%","%#{value}%","%#{value}%","%#{value}%")
  end  
end
