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

  default_scope order: 'issues.created_at ASC'

  def can_be_solved?
    if self.status == "pending" or self.status == "not approved"
      true if not self.who_is_solving
    end
  end

  def can_be_finished_by?(user, type)
    case type
      when "solving"
        true if self.who_is_solving == user  and self.status == "in progress"
      when "validating"
        true if self.who_is_validating == user  and self.status == "validating"
    end
  end

  def can_be_validated_by?(user)
    if self.status == "waiting for validation"
      true if self.who_is_solving != user
    end
  end

end