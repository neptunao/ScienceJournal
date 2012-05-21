require 'spec_helper'

describe Article do
  after :all do
    Article.destroy_all
    Author.destroy_all
    DataFile.destroy_all
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
    article = Article.new(title: 'test', authors: [FactoryGirl.create(:author)])
    article.data_files = []
    article.should_not be_valid
    article.data_files = fill_with(times_count: 6, object: :data_file)
    article.should_not be_valid
    article.data_files = fill_with(times_count: 3, object: :data_file)
    article.should_not be_valid
    (4..5).each_with_index do |i|
      article.data_files = fill_with(times_count: i, object: :data_file)
      article.should be_valid
    end
  end

  it 'destroy old data_files before save' do
    DataFile.destroy_all
    article = Article.new(title: 'test', authors: [FactoryGirl.create(:author)])
    article.data_files = fill_with(times_count: 1, object: :data_file)
    article.data_files = fill_with(times_count: 5, object: :data_file)
    article.data_files.count.should be 6
    article.save
    article.data_files.count.should be 5
    DataFile.count.should be 5
  end

  it 'data_files accessor test' do
    article = Article.new(title: 'test', authors: [FactoryGirl.create(:author)])
    article.data_files = fill_with(times_count: 5, object: :data_file)
    article.article.should be article.data_files[0]
    article.resume_rus.should be article.data_files[1]
    article.resume_eng.should be article.data_files[2]
    article.cover_note.should be article.data_files[3]
    article.review.should be article.data_files[4]
  end

  it 'should has 1..11 authors' do
    article = Article.new(title: 'test', data_files: fill_with(times_count: 5, object: :data_file))
    article.should_not be_valid
    authors = []
    12.times { |i| authors << FactoryGirl.create(:author) }
    article.authors = authors
    article.should_not be_valid
    article.authors = fill_with(times_count: 1, object: :author)
    article.should be_valid
    article.authors = fill_with(times_count: 11, object: :author)
    article.should be_valid
  end

  def fill_with(params)
    data_files = []
    params[:times_count].times { |i| data_files << FactoryGirl.create(params[:object]) }
    data_files
  end
end
