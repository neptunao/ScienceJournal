require 'spec_helper'

def create_valid_journal
  j = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
  j.update_attribute(:data_files, [FactoryGirl.create(:journal_file)])
  j.update_attribute(:articles, [create_article])
  j
end

describe Journal do
  before :each do
    DataFile.destroy_all
  end

  def create_article
    Article.create!(title: 'test',
                   data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                   author_ids: [FactoryGirl.create(:author).id])
  end

  it 'mush have name' do
    j = create_valid_journal
    j.name = nil
    j.should_not be_valid
  end

  it 'must have num' do
    j = create_valid_journal
    j.num = nil
    j.should_not be_valid
  end

  it 'num must be > 1' do
    j = create_valid_journal
    j.num = -1
    j.should_not be_valid
  end

  it 'must have journal_file' do
    j = create_valid_journal
    j.data_files = []
    j.should_not be_valid
  end

  it 'must have category' do
    j = create_valid_journal
    j.category = nil
    j.should_not be_valid
  end

  it 'return valid journal_file' do
    journal = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
    journal.data_files = [FactoryGirl.create(:data_file)]
    journal.journal_file.should be_nil
    journal.data_files = [FactoryGirl.create(:journal_file)]
    journal.journal_file.should_not be_nil
  end

  it 'return valid cover image' do
    journal = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
    journal.data_files = [FactoryGirl.create(:data_file)]
    journal.cover_image.should be_nil
    journal.data_files = [FactoryGirl.create(:cover_image)]
    journal.cover_image.should_not be_nil
  end

  it 'delete data_files without owner' do
    DataFile.destroy_all
    journal = create_valid_journal
    journal.update_attribute(:data_files, [])
    journal.data_files = [FactoryGirl.create(:data_file)]
    journal.data_files = [FactoryGirl.create(:journal_file)]
    journal.should be_valid
    journal.save!
    Article.destroy_all
    DataFile.count.should be 1
  end

  it 'data_files count must be in 1..2' do
    journal = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
    journal.data_files = [FactoryGirl.create(:data_file), FactoryGirl.create(:journal_file), FactoryGirl.create(:cover_image)]
    journal.should_not be_valid
  end

  it 'should have minimum 1 article' do
    journal = create_valid_journal()
    journal.articles = []
    journal.should_not be_valid
  end

  it 'destroy data files when destroy' do
    DataFile.destroy_all
    journal = create_valid_journal
    DataFile.count.should be > 0
    journal.articles.destroy_all
    DataFile.count.should be > 0
    journal.destroy
    DataFile.count.should be 0
  end
end
