# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Google omniauth authentication', type: :feature do
  let(:mock_user_email) { 'mockuser@email.com' }
  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  after do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = nil
  end

  before(:each) do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({ provider: 'google_oauth2',
                                                                         uid: '123456789',
                                                                         info: { email: mock_user_email } })
  end

  it 'successfully authenticate with valid credentials' do
    visit '/'

    expect(page).to have_content('Sign in with Google')
    click_button('Sign in with Google')

    expect(page).to have_content('Logout')
  end

  it 'handle authentication failure with invalid credentials' do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials

    visit '/'

    click_button('Sign in with Google')
    expect(page).to have_content('There was a problem signing you in. Please register or try signing in later.')
  end

  it 'signing in for a first time save user in db' do
    visit '/'

    click_button('Sign in with Google')

    expect(page).to have_content('Logout')
    user = User.find_by(email: mock_user_email)

    expect(user).not_to be_nil
    expect(user[:email]).to eq(mock_user_email)
  end
end
