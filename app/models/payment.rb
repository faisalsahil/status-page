class Payment < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :card_number,:card_code,:card_exp_date,:user_id,:token,:subscription_id

  belongs_to :user
end
