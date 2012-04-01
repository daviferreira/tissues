class Project < ActiveRecord::Base
  attr_accessible :name, :url, :status
  belongs_to :user
  
  has_many :issues, dependent: :destroy

  validates :name, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'projects.created_at DESC'

  def related_users
    users = [self.user]
    self.issues.each do |issue| 
      users.push(issue.user) unless users.include? issue.user 
      issue.comment_threads.each { |comment| users.push(comment.user) unless users.include? comment.user }
    end
    return users
  end
end