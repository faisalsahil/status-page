class Maintenance < ActiveRecord::Base
	attr_accessible :component_id, :description, :end_at, :start_at, :title

	validates_presence_of :title, :start_at, :end_at
	belongs_to :component
	validate :stop_date


	def stop_date
	  errors.add(:end_at, "stop date cannot be older than start date") if end_at < start_at
	end
end
