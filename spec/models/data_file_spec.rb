require 'spec_helper'
include ActionDispatch::TestProcess

describe DataFile do
  before :all do
    @short_filename = 'public/data/test_upload.txt'
    @filename = "#{Rails.root}/#@short_filename"
  end

  after :all do
    DataFile.destroy_all
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

  it 'upload create new DataFile record' do
    data_file = DataFile.upload(fixture_file_upload("/test_data/test_upload.txt"))
    data_file.should be_a DataFile
    data_file.filename.should be_eql @short_filename
    DataFile.find(data_file.id).should_not be nil
  end

  it 'upload with tag create record with tag' do
    data_file = DataFile.upload(fixture_file_upload("/test_data/test_upload.txt"), 'test_tag')
    data_file.tag.should eql 'test_tag'
  end

  it 'destory action delete file' do
    data_file = DataFile.upload(fixture_file_upload("/test_data/test_upload.txt"))
    data_file.destroy
    File.exist?(@filename).should be_false
  end
end
