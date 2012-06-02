class DataFile < ActiveRecord::Base
  belongs_to :article
  belongs_to :journal
  attr_accessible :filename, :tag
  validates :filename, presence: true, uniqueness: true
  after_destroy :after_destroy_action

  def self.destroy_unowned
    DataFile.where(article_id: nil, journal_id: nil).destroy_all
  end

  def self.upload(file, tag = '')
    path = File.join('public/data', file.original_filename)
    File.open(path, "wb") { |f| f.write(file.read) }
    filename = "data/#{file.original_filename}"
    DataFile.create!(filename: filename, tag: tag)
  end

  private

  def full_path
    "public/#{filename}"
  end

  private

  def after_destroy_action
    File.delete(full_path) if File.exist? full_path #TODO validates exist filename
  end
end
