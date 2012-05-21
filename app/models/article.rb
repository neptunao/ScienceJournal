class Article < ActiveRecord::Base
  attr_accessible :status, :title, :data_files, :authors #TODO remove authors if author_ids using in params
  has_many :data_files
  has_and_belongs_to_many :authors
  has_one :censor
  accepts_nested_attributes_for :authors
  validates :title, :status, presence: true
  validates :data_files, :length => { in: 4..5 }
  validates :authors, :length => { in: 1..11 }
  after_save :after_save_action

  def article
    data_files[0]
  end

  def resume_rus
    data_files[1]
  end

  def resume_eng
    data_files[2]
  end

  def cover_note
    data_files[3]
  end

  def review
    data_files[4]
  end

  def after_save_action
    DataFile.where(article_id: nil).destroy_all
  end
end
