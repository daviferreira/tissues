class Issue < ActiveRecord::Base
	attr_accessible :content, :project_id, :who_is_solving, :who_is_validating, :tag_list

	belongs_to :user
	belongs_to :project

  acts_as_taggable
	
	validates :user_id, presence: true
	validates :project_id, presence: true
	validates :content, presence: true

  default_scope order: 'issues.updated_at DESC'
end