require 'spec_helper'

describe 'User Model' do
  let(:user) { Struct.new(:email, :password, :auth_token)['john@example.com', 'password', 'AUTH'] }

  context 'self#find_by_reset' do
    it 'should find by email and auth token and update attributes' do
      test_user = stub
      test_user.should_receive(:update_attribute)
      User.should_receive(:find_by_email_and_auth_token).
        with(user.email, user.auth_token).and_return(test_user)
      User.find_by_reset(user.email, user.auth_token)
    end

    it 'should return nil on fail' do
      User.find_by_reset('', '').should == nil
    end
  end

  context 'self#create_subscriber' do
    it 'should return a new user' do
      test_user = User.create_subscriber(user)
      test_user.should be_a(User)
    end

    it 'should have errors when invalid' do
      test_user = User.create_subscriber({email: '', password: ''})
      test_user.should_not be_valid
    end
  end

  context '#update_settings' do
    let(:test_user) { User.create_subscriber(user) }
    before(:each) { test_user.save }

    it 'should update user settings' do
      new_email = 'joe@example.com'
      old_password = test_user.password
      test_user.update_settings({email: new_email, password: ''})
      test_user.email.should == new_email
      test_user.password.should == old_password
    end

    it 'should allow password updates' do
      new_password = '123456'
      old_password = test_user.password
      test_user.update_settings({email: user.email, password: new_password})
      test_user.password.should_not == old_password
    end

    it 'should return false on invalid update' do
      result = test_user.update_settings({email: '', password: ''})
      result.should be_false
    end
  end
end
