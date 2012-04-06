class Issue < ActiveRecord::Base
	attr_accessible :content, :project_id, :who_is_solving, :who_is_validating, :tag_list, :status

	belongs_to :user
	belongs_to :project

  belongs_to :who_is_solving, :class_name => 'User', :foreign_key => 'who_is_solving'
  belongs_to :who_is_validating, :class_name => 'User', :foreign_key => 'who_is_validating'

  acts_as_taggable
  acts_as_commentable
	
	validates :user_id, presence: true
	validates :project_id, presence: true
	validates :content, presence: true

  default_scope order: 'issues.updated_at DESC'
end