class Client < ActiveRecord::Base
  attr_accessible :phone, :user_id

  belongs_to :user
  validates_presence_of :phone
end
