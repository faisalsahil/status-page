class Component < ActiveRecord::Base
  attr_accessible :description, :name, :status_id, :status

  has_many :incidents
  has_one :maintenance
  belongs_to :user

  def self.update_by_email(message)	
    if Component.find_by_random_key(message.subject).present?
    	comp = Component.find_by_random_key(message.subject)
    	mailbody = message.body.decoded.to_s
    	statuses = Status.where("user_id = ?", comp.user_id)
    	successfullyupdated = false
    	statuses.each do |status|
	    	i = nil
		  	i = mailbody.index(status.name)
		    if i != nil
		    	comp.status_id = status.id
		    	comp.save!
		    	successfullyupdated = true
		    end
		  end
  		if successfullyupdated == false
  			NotificationMailer.errorMailReceive(message.from).deliver
  		else
  			NotificationMailer.successMailComponentUpdate(message.from,comp).deliver
  		end
    else
    	NotificationMailer.errorMailReceive(message.from).deliver
    end
  end
end
