require 'rails_helper'
require_relative '../support/vcr_setup'

RSpec.describe 'post creation', type: :feature do
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
      visit '/posts'

      expect(page).to have_content('You need to sign in or sign up before continuing.')
      expect(page).to have_current_path('/users/sign_in')
    end
  end

  context 'deleting posts with authenticated user' do
    it 'successfully delete post' do
      sign_in user

      visit '/'

      expect(page).to have_content(post.notice)
      expect(page).to have_button('Delete')

      click_button 'Delete'

      expect(page).not_to have_content(post.city)
      expect(page).not_to have_button('Delete')
      expect(page).not_to have_button('Edit')
    end
  end
end
