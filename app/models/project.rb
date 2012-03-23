class Project < ActiveRecord::Base
  attr_accessible :name, :url, :status
  belongs_to :user
  
  has_many :issues, dependent: :destroy

  validates :name, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'projects.created_at DESC'
end