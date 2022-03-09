# frozen_string_literal: true

require 'webmock/rspec'
require_relative '../support/vcr_setup'

RSpec.describe 'OpenWeatherApi' do
  before do
    allow(Rails.application.credentials).to receive(:fetch).with(:open_weather_api_key).and_return('token')
  end

  it 'with valid city returnc correct temperature' do
    VCR.use_cassette('valid_city') do
      response = OpenWeather::OpenWeatherApi.new.temperature_by_city_name('Warszawa')
      expect(response).to be_a(Integer)
    end
  end
end
