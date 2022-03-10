require 'rails_helper'
require_relative '../support/vcr_setup'

RSpec.describe 'post edition', type: :feature do
  include Devise::Test::IntegrationHelpers

  before do
    allow(Rails.application.credentials).to receive(:fetch).with(:open_weather_api_key).and_return('token')
  end

  let(:user) { create(:user) }
  let!(:post) do
    VCR.use_cassette('valid_city_Warszawa') do
      create(:post, city: 'Warszawa', user: user)
    end
  end

  context 'when user is not signed in redirect to sign_in page' do
    it do
      visit "/posts/#{post.id}/edit"

      expect(page).to have_content('You need to sign in or sign up before continuing.')
      expect(page).to have_current_path('/users/sign_in')
    end
  end

  context 'editing posts with authenticated user' do
    it 'successfully update post with valid data' do
      VCR.use_cassette('valid_city_Lublin') do
        sign_in user

        visit '/'

        expect(page).to have_content(post.city)
        expect(page).to have_link('Edit')

        click_link 'Edit'

        expect(page).to have_content('Edit post')
        expect(page).to have_field('Notice', with: post.notice)
        expect(page).to have_field('City', with: post.city)

        fill_in 'Notice', with: 'Notice edited'
        fill_in 'City', with: 'Lublin'

        click_button 'Save'

        expect(page).to have_current_path('/posts')
        expect(page).to have_content('Post was successfully updated.')
        expect(page).to have_content('Lublin')
        expect(page).to have_content('Notice edited')
      end
    end

    it 'display error when notice too short' do
      sign_in user

      visit "/posts/#{post.id}/edit"

      expect(page).to have_content('Edit post')
      expect(page).to have_field('Notice', with: post.notice)
      expect(page).to have_field('City', with: post.city)
      fill_in 'Notice', with: '1'

      click_button 'Save'

      expect(page).to have_content('Notice is too short (minimum is 3 characters)')
    end

    it 'display error when notice too long' do
      sign_in user

      visit "/posts/#{post.id}/edit"

      expect(page).to have_content('Edit post')
      expect(page).to have_field('Notice', with: post.notice)
      expect(page).to have_field('City', with: post.city)
      fill_in 'Notice', with: '1' * 501

      click_button 'Save'

      expect(page).to have_content('Notice is too long (maximum is 500 characters)')
    end

    it 'display error when edited city was not found' do
      VCR.use_cassette('invalid_city') do
        sign_in user

        visit "/posts/#{post.id}/edit"

        expect(page).to have_content('Edit post')
        expect(page).to have_field('Notice', with: post.notice)
        expect(page).to have_field('City', with: post.city)

        fill_in 'City', with: 'invalid city'

        click_button 'Save'

        expect(page).to have_content('City not found')
      end
    end
  end
end
