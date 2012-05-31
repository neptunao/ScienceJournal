class Journal < ActiveRecord::Base
  COVER_IMAGE_FILE_TAG = 'cover_image'
  JOURNAL_FILE_TAG = 'journal'

  attr_accessible :category_id, :name, :num, :category_id, :data_files
  has_many :data_files, dependent: :destroy
  has_many :articles
  belongs_to :category
  validates :name, :num, :category, :journal_file, presence: true
  validates :num, inclusion: { in: 1..Float::INFINITY }
  validates :data_files, length: { maximum: 2 }
  validates :articles, length: { minimum: 1 }
  after_save :after_save_action

  def journal_file
    data_files.find_by_tag(JOURNAL_FILE_TAG)
  end

  def cover_image
    data_files.find_by_tag(COVER_IMAGE_FILE_TAG)
  end

  private

  def after_save_action
    DataFile.destroy_unowned
  end
end
