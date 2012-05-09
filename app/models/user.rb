class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :is_approved, :user_roles, :role_ids
  validates :name, presence: true, uniqueness: true
  # attr_accessible :title, :body
  has_and_belongs_to_many :roles
  before_save :update_approved

  def initialize(*attr)
    super
    self.user_roles = [Role.guest_role] if user_roles.empty?
  end

  def update_approved
    self.is_approved = role? 'author'
    true
  end

  def user_roles=(value)
    self.roles = value
    update_approved
  end

  def user_roles
    self.roles
  end

  def role?(role)
    user_roles.any?{|r| r.name.to_s.downcase == role.to_s.downcase}
  end
end
