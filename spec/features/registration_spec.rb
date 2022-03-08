# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User registration', type: :feature do
  let(:test_email) { 'testuser@email.com' }
  let(:test_password) { 'password' }

  before(:each) do
    visit '/users/sign_up'
  end

  it 'successfully sign up with valid data' do
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
    expect(page).to have_field('Password confirmation')

    fill_in 'Email', with: test_email
    fill_in 'Password', with: test_password
    fill_in 'Password confirmation', with: test_password

    click_button 'Sign up'
    expect(page).to have_content('Welcome! You have signed up successfully.')

    user = User.find_by(email: test_email)
    expect(user).not_to be_nil
    expect(user[:email]).to eq(test_email)
  end

  it 'sending empty form display appropriate errors' do
    click_button 'Sign up'

    expect(page).to have_content('2 errors prohibited this user from being saved:')
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end

  it 'display error when password_confirmation missmatch password' do
    fill_in 'Email', with: test_email
    fill_in 'Password', with: test_password
    fill_in 'Password confirmation', with: 'different_password'

    click_button 'Sign up'

    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it 'invalid password shorter than 6 characters' do
    fill_in 'Email', with: test_email
    fill_in 'Password', with: 'asdf'
    fill_in 'Password confirmation', with: 'asdf'

    click_button 'Sign up'

    expect(page).to have_content('Password is too short (minimum is 6 characters)')
  end

  it 'email already taken' do
    user = create(:user)

    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: test_password
    fill_in 'Password confirmation', with: test_password

    click_button 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end
end
