require 'rails_helper'
require_relative '../support/vcr_setup'

RSpec.describe 'post creation', type: :feature do
  include Devise::Test::IntegrationHelpers

  before do
    allow(Rails.application.credentials).to receive(:fetch).with(:open_weather_api_key).and_return('token')
  end

  let(:user) { create(:user) }
  let(:city) { 'Warszawa' }
  let(:notice) { 'Notice' }

  context 'when user is not sign in redirect to sign_in page' do
    it do
      visit '/posts'

      expect(page).to have_content('You need to sign in or sign up before continuing.')
      expect(page).to have_current_path('/users/sign_in')
    end
  end

  context 'creating post with authenticated user' do
    it 'successfully create post with valid data' do
      VCR.use_cassette('valid_city_Warszawa') do
        sign_in user

        visit '/'

        expect(page).to have_field('City')
        expect(page).to have_field('Notice')
        expect(page).to have_button('Save')

        fill_in 'City', with: city
        fill_in 'Notice', with: notice

        click_button 'Save'

        expect(page).to have_content(city)
        expect(page).to have_content(notice)
        expect(page).to have_link('Edit')
        expect(page).to have_button('Delete')
      end
    end

    it 'displays appriopriate error when typed city not found' do
      VCR.use_cassette('invalid_city') do
        sign_in user

        visit '/'

        fill_in 'City', with: 'invalid city'
        fill_in 'Notice', with: notice

        click_button 'Save'

        expect(page).to have_content('City not found')
      end
    end

    it 'displays error when notice length is less than 3 characters' do
      VCR.use_cassette('valid_city_Warszawa') do
        sign_in user

        visit '/'

        fill_in 'City', with: city
        fill_in 'Notice', with: '1'

        click_button 'Save'

        expect(page).to have_content('Notice is too short (minimum is 3 characters)')
      end
    end

    it 'displays error when notice length is greater than 500 characters' do
      VCR.use_cassette('valid_city_Warszawa') do
        sign_in user

        visit '/'

        fill_in 'City', with: city
        fill_in 'Notice', with: '1' * 501

        click_button 'Save'

        expect(page).to have_content('Notice is too long (maximum is 500 characters)')
      end
    end

    it 'when city not found and notice too short display appriopriate errors' do
      VCR.use_cassette('invalid_city') do
        sign_in user

        visit '/'

        fill_in 'City', with: 'invalid city'
        fill_in 'Notice', with: '1'

        click_button 'Save'

        expect(page).to have_content('City not found')
        expect(page).to have_content('Notice is too short (minimum is 3 characters)')
      end
    end
  end
end
