class CreateArticlesAuthors < ActiveRecord::Migration
  def up
    create_table 'articles_authors', :id => false do |t|
      t.column :article_id, :integer
      t.column :author_id, :integer
    end
  end

  def down
    drop_table 'articles_authors'
  end
end
