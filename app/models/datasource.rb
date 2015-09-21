class Datasource < ActiveRecord::Base
  attr_accessible :ds_appkey, :ds_email, :ds_pass, :source_name, :user_id

  belongs_to :user
  has_many :metrics
end
