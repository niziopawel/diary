# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign in with email and password', type: :feature do
  before(:each) do
    @user = create(:user)
    visit '/'
  end

  it 'successfully authenticate user with valid email and password' do
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    click_button 'Log in'
    expect(page).to have_content('Signed in successfully.')
  end

  it 'handle authentication error with invalid email' do
    fill_in 'Email', with: 'invalid@mail.com'
    fill_in 'Password', with: @user.password

    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password.')
  end

  it 'handle authentication error with invalid email' do
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'wrongpassword'

    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password.')
  end
end
