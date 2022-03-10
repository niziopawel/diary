require_relative '../support/vcr_setup'
require 'rails_helper'

RSpec.describe 'OpenWeatherApi' do
  before do
    allow(Rails.application.credentials).to receive(:fetch).with(:open_weather_api_key).and_return('token')
  end

  it 'with valid city return correct temperature' do
    VCR.use_cassette('valid_city_Warszawa') do
      response = OpenWeather::GetCityTemperature.new(city: 'Warszawa').call

      expect(response.success).not_to be_nil
      expect(response.success).to be_a(Float)
      expect(response.errors).to be_empty
    end
  end

  it 'with invalid city return error' do
    VCR.use_cassette('invalid_city') do
      response = OpenWeather::GetCityTemperature.new(city: 'invalid city').call

      expect(response.success).to be_nil
      expect(response.errors).not_to be_empty
      expect(response.errors).to include(%i[city not_found])
    end
  end

  it 'raise unauthorized exception with invalid api_key' do
    allow(Rails.application.credentials).to receive(:fetch).with(:open_weather_api_key).and_return('invalid_token')
    VCR.use_cassette('unauthorized') do
      expect { OpenWeather::GetCityTemperature.new(city: 'Warszawa').call }.to raise_error('unauthorized')
    end
  end
end
