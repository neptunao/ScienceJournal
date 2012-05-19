class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :is_approved, :role_ids
  validates :name, presence: true, uniqueness: true
  # attr_accessible :title, :body
  has_and_belongs_to_many :roles
  has_one :author
  before_create :post_init

  def initialize(*attr)
    super
    self.roles = [Role.guest_role] if roles.empty?
  end

  def role?(role)
    roles.any?{|r| r.name.to_s.downcase == role.to_s.downcase}
  end

  private

  def post_init
    self.is_approved = !role?('censor')
    true
  end

end
