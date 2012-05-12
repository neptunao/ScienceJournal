require 'spec_helper'

describe Category do
  before :all do
    Category.delete_all
  end
  it 'should return correct json' do
    top_category = Category.create(title: 'category1')
    sub_category1 = Category.create(title: 'sub_category1')
    sub_category1.parent_category = top_category
    sub_category1.save
    sub_category2 = Category.create(title: 'sub_category2')
    sub_category2.parent_category = top_category
    sub_category2.save
    json = top_category.as_json
    json.should include :title
    json.should include :children
    encoded_children = ActiveSupport::JSON.encode(json[:children])
    encoded_children.should eql ActiveSupport::JSON.encode([sub_category2, sub_category1].as_json)
  end
end
