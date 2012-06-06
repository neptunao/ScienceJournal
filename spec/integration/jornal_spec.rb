require 'spec_helper'

describe 'Journals' do
  it 'visit nested article' do
    visit '/logout'
    journal = create_journal
    article = journal.articles[0]
    article.update_attribute(:status, Article::STATUS_PUBLISHED)
    visit journal_article_path(journal, article.id)
    current_url.should eql journal_article_path(journal, article.id)
  end

end