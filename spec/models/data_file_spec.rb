require 'spec_helper'
include ActionDispatch::TestProcess

describe DataFile do
  before :all do
    @filename = "#{Rails.root}/public/data/test_upload.txt"
  end
  after :all do
    DataFile.delete_all
    File.delete(@filename)
  end
  it 'filename should exists' do
    DataFile.new(filename: '').should_not be_valid
  end
  it 'filename should be unique' do
    DataFile.create(filename: '1')
    DataFile.new(filename: '1').should_not be_valid
  end
  it 'upload action is successfull' do
    File.exist?(@filename).should be_false
    DataFile.upload(fixture_file_upload("/test_data/test_upload.txt"))
    File.exist?(@filename).should be_true
    File.open(@filename, 'r') { |f| f.read.should be_eql "test" }
  end
  it 'uploading non-existing file does not create new file' do
    begin
      lambda { DataFile.upload(fixture_file_upload("/invalid.txt")) }.should raise_error
    ensure
      File.exist?("#{Rails.root}/public/data/invalid.txt").should be_false
    end
  end
end
