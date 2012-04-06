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
      ['user', 'who_is_solving', 'who_is_validating'].each do |field|
        users.push(issue.send(field)) unless not issue.send(field) or users.include? issue.send(field)
      end
      issue.comment_threads.each { |comment| users.push(comment.user) unless users.include? comment.user }
    end
    return users
  end
end