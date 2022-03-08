class Post < ApplicationRecord
  belongs_to :user

  validates :city, presence: true
  validates :notice, presence: true, length: { minimum: 3, maximum: 500 }

  def formatted_temperature
    "#{temperature}°C"
  end
end
