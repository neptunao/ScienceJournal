require 'spec_helper'

describe Article do
  after :all do
    Article.destroy_all
    Author.destroy_all
    DataFile.destroy_all
  end

  def create_data_files
    f1 = DataFile.create(filename: '0', tag: Article::ARTICLE_FILE_TAG)
    f2 = DataFile.create(filename: '1', tag: Article::RESUME_RUS_FILE_TAG)
    f3 = DataFile.create(filename: '2', tag: Article::RESUME_ENG_FILE_TAG)
    f4 = DataFile.create(filename: '3', tag: Article::COVER_NOTE_FILE_TAG)
    f5 = DataFile.create(filename: '4', tag: Article::REVIEW_FILE_TAG)
    [f2, f3, f1, f4, f5]
  end

  def create_valid_article
    article = Article.new(title: 'test', authors: [FactoryGirl.create(:author)])
    article.data_files = create_data_files
    article
  end

  it 'should have title' do
    Article.new(title: '').should_not be_valid
  end

  it 'should have status' do
    Article.new(title: 'test', status: nil).should_not be_valid
  end

  it 'should have article data_file' do
    article = create_valid_article
    article.data_files.destroy(article.article.id)
    article.should_not be_valid
  end

  it 'should have resume_rus data_file' do
    article = create_valid_article
    article.data_files.destroy(article.resume_rus.id)
    article.should_not be_valid
  end

  it 'should have resume_eng data_file' do
    article = create_valid_article
    article.data_files.destroy(article.resume_eng.id)
    article.should_not be_valid
  end

  it 'should have cover_note data_file' do
    article = create_valid_article
    article.data_files.destroy(article.cover_note.id)
    article.should_not be_valid
  end

  it 'status should be 0 by default' do
    Article.new(title: 'test').status.should be 0
  end

  it 'datafiles num should be valid' do
    article = create_valid_article
    article.data_files << DataFile.create(filename: 'test')
    article.should_not be_valid
  end

  it 'destroy old data_files before save' do
    DataFile.destroy_all
    article = Article.new(title: 'test', authors: [FactoryGirl.create(:author)])
    article.data_files = [DataFile.create(filename: 'test1')]
    article.data_files = create_data_files
    article.data_files.count.should be 6
    article.save
    article.data_files.count.should be 5
    DataFile.count.should be 5
  end

  it 'data_files accessor test' do
    article = create_valid_article
    article.article.should eql article.data_files.find_by_tag(Article::ARTICLE_FILE_TAG)
    article.resume_rus.should eql article.data_files.find_by_tag(Article::RESUME_RUS_FILE_TAG)
    article.resume_eng.should eql article.data_files.find_by_tag(Article::RESUME_ENG_FILE_TAG)
    article.cover_note.should eql article.data_files.find_by_tag(Article::COVER_NOTE_FILE_TAG)
    article.review.should eql article.data_files.find_by_tag(Article::REVIEW_FILE_TAG)
  end

  it 'should has 1..11 authors' do
    article = create_valid_article
    article.update_attribute(:authors, [])
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
