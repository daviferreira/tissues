class Issue < ActiveRecord::Base
	attr_accessible :content, :project_id, :who_is_solving, :who_is_validating

	belongs_to :user
	belongs_to :project
	
	validates :user_id, presence: true
	validates :project_id, presence: true
	validates :content, presence: true
end