class DataFile < ActiveRecord::Base
  attr_accessible :filename
  validates :filename, presence: true, uniqueness: true

  def self.upload(file)
    path = File.join('public/data', file.original_filename)
    File.open(path, "wb") { |f| f.write(file.read) }
    DataFile.create!(filename: path)
  end
end
