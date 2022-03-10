# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { Post.new(user: create(:user), notice: notice, city: city) }
  let(:city) { 'Warszawa' }
  let(:notice) { 'Notice' }

  let(:weather_service_mock) { instance_double(OpenWeather::GetCityTemperature) }

  before do
    allow(OpenWeather::GetCityTemperature).to receive(:new).with(city: post.city).and_return(weather_service_mock)
    allow(weather_service_mock).to receive(:call).and_return(
      OpenWeather::GetCityTemperature::Result.new(success, errors)
    )
  end

  context 'when Service returns temperature' do
    let(:success) { 15.1 }
    let(:errors) { [] }
    let(:post) { build(:post) }

    it 'valid with valid attributes' do
      expect(post).to be_valid
      expect(post.temperature).to eq(15)
    end

    context 'when city is missing' do
      let(:city) { '' }

      it { is_expected.to be_invalid }
    end

    context 'when notice is missing' do
      let(:notice) { '' }

      it { is_expected.to be_invalid }
      it { expect(OpenWeather::GetCityTemperature).not_to receive(:new) }
    end

    context 'when notice length less than 3' do
      let(:notice) { '12' }

      it { is_expected.to be_invalid }
      it { expect(OpenWeather::GetCityTemperature).not_to receive(:new) }
    end

    context 'when notice length greater than 3' do
      let(:notice) { 'a' * 501 }

      it { is_expected.to be_invalid }
      it { expect(OpenWeather::GetCityTemperature).not_to receive(:new) }
    end
  end

  context 'when service returns city not found' do
    let(:success) { nil }
    let(:errors) { [%i[city not_found]] }
    let(:post) { build(:post, city: 'uknown city') }

    it 'set error to city when api service returns city not found' do
      expect(post).not_to be_valid
      expect(post.errors.full_messages).to include('City not found')
    end
  end
end
