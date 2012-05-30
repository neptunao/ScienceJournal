require 'spec_helper'

describe Journal do
  it 'mush have name' do
    Journal.new(num: 0).should_not be_valid
  end

  it 'must have num' do
    Journal.new(name: 'a', num: nil).should_not be_valid
  end

  it 'num must be > 1' do
    Journal.new(name: 'a', num: -1).should_not be_valid
  end

  it 'must have summary_file' do
    Journal.new(name: 'a', num: 1).should_not be_valid
  end

  it 'must have category' do
    Journal.new(name: 'a', num: 1, data_files: [FactoryGirl.create(:journal_file)]).should_not be_valid
  end

  it 'must have journal_file' do
    Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id).should_not be_valid
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
    journal = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
    journal.data_files = [FactoryGirl.create(:data_file)]
    journal.data_files = [FactoryGirl.create(:journal_file)]
    journal.save!
    DataFile.count.should be 1
  end

  it 'data_files count must be in 1..2' do
    journal = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
    journal.data_files = [FactoryGirl.create(:data_file), FactoryGirl.create(:journal_file), FactoryGirl.create(:cover_image)]
    journal.should_not be_valid
  end
end
