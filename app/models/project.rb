class Project < ActiveRecord::Base
  attr_accessible :name, :status
  belongs_to :user
  
  validates :name, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'projects.created_at DESC'
end
