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
  it 'datafiles num should be 2..4' do
    article = Article.new(title: 'test')
    article.data_files = []
    article.should_not be_valid
    article.data_files = fill_with_data_files(5)
    article.should_not be_valid
    article.data_files = fill_with_data_files(1)
    article.should_not be_valid
    (2..3).each_with_index do |i|
      article.data_files = fill_with_data_files(i)
      article.should be_valid
    end
  end
  it 'destroy old data_files before save' do
    DataFile.delete_all
    article = Article.new(title: 'test')
    article.data_files = fill_with_data_files(1)
    article.data_files = fill_with_data_files(3)
    article.data_files.count.should be 4
    article.save
    article.data_files.count.should be 3
    DataFile.count.should be 3
  end
  def fill_with_data_files(times_count)
    data_files = []
    times_count.times { |i| data_files << FactoryGirl.create(:data_file) }
    data_files
  end
end
