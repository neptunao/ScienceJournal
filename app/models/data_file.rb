class DataFile < ActiveRecord::Base
  attr_accessible :filename, :tag
  validates :filename, presence: true, uniqueness: true
  after_destroy :after_destroy_action

  def self.upload(file, tag = '')
    path = File.join('public/data', file.original_filename)
    File.open(path, "wb") { |f| f.write(file.read) }
    DataFile.create!(filename: path, tag: tag)
  end

  private

  def after_destroy_action
    File.delete(filename) if File.exist? filename #TODO validates exist filename
  end
end
