require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = create(:user)
  end

  it 'valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'invalid with invalid email' do
    invalid_emails = ['', '   ', 'asdf', 'email.', 'email@', 'email.com']

    invalid_emails.each do |email|
      @user.email = email

      expect(@user).not_to be_valid
    end
  end

  it 'invalid with empty password' do
    @user.password = ''

    expect(@user).not_to be_valid
  end

  it 'invalid with password length less than 0' do
    @user.password = 'aszcz'

    expect(@user).not_to be_valid
  end

  it 'invalid without unique email' do
    user_duplicate = create(:user).dup

    expect(user_duplicate).not_to be_valid
  end
end
