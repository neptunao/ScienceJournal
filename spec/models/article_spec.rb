require 'spec_helper'

describe Article do
  after :all do
    Article.delete_all
    DataFile.delete_all
  end
  it 'should have title' do
    Article.new(title: '').should_not be_valid
  end
  it 'should have status' do
    Article.new(title: 'test', status: nil).should_not be_valid
  end
  it 'status should be 0 by default' do
    Article.new(title: 'test').status.should be 0
  end
  it 'datafiles num should be only 4' do
    article = Article.new(title: 'test')
    article.data_files = []
    article.should_not be_valid
    article.data_files = fill_with_data_files(5)
    article.should_not be_valid
    article.data_files = fill_with_data_files(4)
    article.should be_valid
  end
  it 'destroy old data_files before save' do
    DataFile.delete_all
    article = Article.new(title: 'test')
    article.data_files = fill_with_data_files(1)
    article.data_files = fill_with_data_files(4)
    article.data_files.count.should be 5
    article.save
    article.data_files.count.should be 4
    DataFile.count.should be 4
  end
  def fill_with_data_files(times_count)
    data_files = []
    times_count.times { |i| data_files << FactoryGirl.create(:data_file) }
    data_files
  end
end
