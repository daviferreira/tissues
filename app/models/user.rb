class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar,
                  :avatar_file_name
  
  has_many :projects, dependent: :destroy
  has_many :issues, dependent: :destroy

  has_attached_file :avatar, :styles => { :medium => "80x80#", :thumb => "28x28#" }, 
                    :default_url => '/assets/missing_:style.png'
  
  validates :name, :presence => true, length: { maximum: 50 }

  validates_attachment :avatar, :content_type => { :content_type => /image/ },
                                :size => { :in => 0..2.megabytes }
  
  default_scope order: 'users.name ASC'
end
