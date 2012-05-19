class Article < ActiveRecord::Base
  attr_accessible :status, :title
  has_many :data_files
  validates :title, :status, presence: true
  validates :data_files, :length => { in: 4..5 }
  after_save :after_save_action

  def after_save_action
    DataFile.where(article_id: nil).destroy_all
  end
end
