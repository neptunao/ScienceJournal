require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, comment the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
    config.include Devise::TestHelpers, :type => :controller
  end
end

Spork.each_run do
  load_roles
end

def create_journal
  j = Journal.new(name: 'a', num: 1, category_id: FactoryGirl.create(:category).id)
  j.update_attribute(:data_files, [FactoryGirl.create(:journal_file)])
  j.update_attribute(:articles, [create_article])
  j
end

def create_article
  Article.create!(title: 'test',
                 data_files: [FactoryGirl.create(:article_file), FactoryGirl.create(:resume_rus), FactoryGirl.create(:resume_eng), FactoryGirl.create(:cover_note)],
                 author_ids: [FactoryGirl.create(:author).id], category_id: FactoryGirl.create(:category).id)
end

def create_data_files
  f1 = DataFile.create(filename: '0', tag: Article::ARTICLE_FILE_TAG)
  f2 = DataFile.create(filename: '1', tag: Article::RESUME_RUS_FILE_TAG)
  f3 = DataFile.create(filename: '2', tag: Article::RESUME_ENG_FILE_TAG)
  f4 = DataFile.create(filename: '3', tag: Article::COVER_NOTE_FILE_TAG)
  f5 = DataFile.create(filename: '4', tag: Article::REVIEW_FILE_TAG)
  [f2, f3, f1, f4, f5]
end

def create_user
  user = FactoryGirl.create(:user)
  user.update_attribute(:person, FactoryGirl.create(:author))
  user
end

def login(user)
  visit '/login'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def load_roles
  Role.create(name: :guest)
  Role.create(name: :author)
  Role.create(name: :censor)
  Role.create(name: :admin)
end