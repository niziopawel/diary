# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  validates :city, presence: true
  validates :notice, presence: true, length: { minimum: 3, maximum: 500 }

  after_validation :set_temperature, if: -> { city.present? && city_changed? }

  def set_temperature
    result = OpenWeather::GetCityTemperature.new.call(city)

    if result.errors.any?
      result.errors.each { |error| errors.add(*error) }
    else
      self.temperature = result.success
    end
  end
end
