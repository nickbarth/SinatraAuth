require 'spec_helper'

describe 'Session Integration' do
  include Integration::Helpers
  let(:user) { Struct.new(:email, :password, :auth_token)['john@example.com', 'password', 'AUTH'] }

  context '/join' do
    after(:all) { visit '/logout' }

    it 'should allow new users' do
      visit '/join'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Join'
      current_path.should == '/members'
      page.should have_content 'Thank you for becoming a member.'
    end

    it 'shows error on invalid users' do
      visit '/join'
      fill_in 'user[email]', with: 'invalid'
      fill_in 'user[password]', with: user.password
      click_button 'Join'
      current_path.should == '/join'
      page.should have_content 'Invalid email address or password.'
    end
  end

  context '/login' do
    after(:all) { visit '/logout' }
    before(:all) do
      User.create Hash[user.each_pair.to_a]
    end

    it 'allow valid logins' do
      visit '/login'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Login'
      current_path.should == '/members'
      page.should have_content 'Successfully logged in.'
    end

    it 'shows error on invalid login' do
      visit '/login'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'invalid'
      click_button 'Login'
      current_path.should == '/login'
      page.should have_content 'Invalid email address or password.'
    end
  end

  context '/logout' do
    before(:all) do
      User.create Hash[user.each_pair.to_a]
      visit '/login'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Login'
    end

    it 'allows user logout' do
      visit '/logout'
      current_path.should == '/'
      page.should have_content 'Successfully logged out.'
    end
  end

  context '/reminder' do
    it 'should display success message' do
      visit '/reminder'
      fill_in 'user[email]', with: user.email
      click_button 'Reset Password'
      current_path.should == '/reminder'
      page.should have_content 'Your password reset email has been sent.'
    end
  end

  context '/reset' do
    after(:all) { visit '/logout' }
    before(:all) { User.create Hash[user.each_pair.to_a] }
    let(:valid_user) { User.first }

    it 'updates a password when valid' do
      visit "/reset/#{valid_user.email}/#{valid_user.auth_token}"
      fill_in 'user[password]', with: 'newpassword'
      click_button 'Set Password'
      page.should have_content 'Password updated.'
      current_path.should == '/members'
    end

    it 'shows an error when invalid' do
      visit "/reset/#{valid_user.email}/invalid"
      page.should have_content 'Invalid email or auth token.'
      visit '/'
    end
  end

  context '/members/account' do
    after(:all) { visit '/logout' }
    before(:all) do
      User.create Hash[user.each_pair.to_a]
      visit '/login'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Login'
    end

    it 'should allow users to update settings' do
      visit '/members/account'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Update Settings'
      current_path.should == '/members/account'
      page.should have_content 'Your settings have been updated.'
    end
  end
end
