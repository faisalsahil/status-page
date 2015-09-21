class Incident < ActiveRecord::Base
  attr_accessible :message, :name, :status, :component_id, :compId, :statId, :statName

  validates_presence_of :name
  belongs_to :user
  belongs_to :component

  attr_accessor :compId, :statId, :statName
end