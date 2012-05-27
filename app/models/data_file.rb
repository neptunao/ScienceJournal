class DataFile < ActiveRecord::Base
  attr_accessible :filename, :tag
  validates :filename, presence: true, uniqueness: true
  after_destroy :after_destroy_action

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

  def after_destroy_action
    File.delete(full_path) if File.exist? full_path #TODO validates exist filename
  end
end
