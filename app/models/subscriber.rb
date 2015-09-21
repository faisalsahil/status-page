class Subscriber < ActiveRecord::Base
  attr_accessible :email, :user_id

  belongs_to :user
  validates_presence_of :email
end
