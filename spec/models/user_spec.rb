# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user, email: email, possword: password) }

  it 'is valid with valid attributes' do
    user = create(:user)
    expect(user).to be_valid
  end

  it 'is invalid with invalid email' do
    invalid_emails = ['', '   ', 'asdf', 'email.', 'email@', 'email.com']

    invalid_emails.each do |email|
      user = build(:user, email: email)

      expect(user).not_to be_valid
    end
  end

  it 'is invalid with empty password' do
    user = build(:user, password: '')

    expect(user).not_to be_valid
  end

  it 'is invalid with password length less than 0' do
    user = build(:user, password: '123')

    expect(user).not_to be_valid
  end

  it 'is invalid without unique email' do
    user = create(:user)
    user_without_unqique_email = build(:user, email: user[:email])

    expect(user_without_unqique_email).not_to be_valid
  end
end
