require 'spec_helper'
include Devise::TestHelpers

describe "Censor profile" do
  before :all do
    User.destroy_all
    Author.destroy_all
    @censor_user = FactoryGirl.create(:censor_user)
    @censor = Censor.create(first_name: 'first_name', last_name: 'last_name', degree: 'degree', post: 'post')
  end

  before :each do
    @censor_user.update_attribute(:person, @censor)
    @censor_user.reload
    login
  end

  after :each do
    visit 'logout'
  end

  def login
    visit '/login'
    fill_in 'Email', with: @censor_user.email
    fill_in 'Password', with: @censor_user.password
    click_button 'Sign in'
  end

  it 'not render censor template when person nil' do
    @censor_user.update_attribute(:person, nil)
    visit show_profile_path
    response.should_not render_template 'censors/_censor_show'
  end

  it 'show action render correct views' do
    visit show_profile_path
    response.should render_template 'layouts/profile'
    response.should render_template 'users/_user_show'
    response.should render_template 'censors/_censor_show'
  end

  it 'edit_personal_info action render correct views' do
    visit edit_personal_path
    response.should render_template 'layouts/profile'
    response.should render_template 'shared/_person'
    response.should render_template 'censors/_censor'
  end

  it 'edit_personal_info action is correct when user has no person' do
    @censor_user.update_attribute(:person, nil)
    visit edit_personal_path
    response.should be_success
  end

  it 'fsdfs' do
    Censor.new(first_name: 'dsf', last_name: 'dsfsf', degree: '5', post: 'sdf').should be_valid
  end

  it 'change user.person on edit_personal_info action' do
    @censor_user.update_attribute(:person, nil)
    visit edit_personal_path
    fill_in 'user[person][first_name]', with: '1'
    fill_in 'user[person][middle_name]', with: '2'
    fill_in 'user[person][last_name]', with: '3'
    fill_in 'user[person][degree]', with: '4'
    fill_in 'user[person][post]', with: '5'
    click_button 'Update User'
    current_url.should eql show_profile_url
    @censor_user.reload
    @censor_user.person.should_not be_nil
    @censor_user.person.first_name.should eql '1'
    @censor_user.person.middle_name.should eql '2'
    @censor_user.person.last_name.should eql '3'
    @censor_user.person.degree.should eql '4'
    @censor_user.person.post.should eql '5'
  end

  it 'update user.person on edit_personal_info action' do
    @censor_user.update_attribute(:person, nil)
    visit edit_personal_path
    @censor_user.update_attribute(:person, @censor)
    old_id = @censor_user.person.id
    fill_in 'user[person][first_name]', with: '1'
    fill_in 'user[person][middle_name]', with: '2'
    fill_in 'user[person][last_name]', with: '3'
    fill_in 'user[person][degree]', with: '4'
    fill_in 'user[person][post]', with: '5'
    click_button 'Update User'
    current_url.should eql show_profile_url
    @censor_user.reload
    @censor_user.person.should_not be_nil
    @censor_user.person.id.should be old_id
    @censor_user.person.first_name.should eql '1'
    @censor_user.person.middle_name.should eql '2'
    @censor_user.person.last_name.should eql '3'
    @censor_user.person.degree.should eql '4'
    @censor_user.person.post.should eql '5'
  end
end