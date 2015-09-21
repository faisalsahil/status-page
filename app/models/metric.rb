class Metric < ActiveRecord::Base
  attr_accessible :datasources_id, :hostname, :name, :status, :userdef_name, :datasourcearr


  belongs_to :datasource

  attr_accessor :datasourcearr
end
