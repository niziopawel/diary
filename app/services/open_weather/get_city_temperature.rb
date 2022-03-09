# frozen_string_literal: true

require 'net/http'

module OpenWeather
  class GetCityTemperature
    Result = Struct.new(:success, :errors) do
      def initialize
        self.errors ||= []
      end
    end
    include HttpStatusCodes

    API_URL = 'https://api.openweathermap.org/data/2.5/weather'

    def initialize
      @result = Result.new
    end

    def call(city_name, unit = 'metric')
      uri = prepare_uri({ q: city_name, units: unit })

      get_temperature(uri)
    end

    private

    def api_key
      Rails.application.credentials.fetch(:open_weather_api_key)
    end

    def prepare_uri(params)
      uri = URI(API_URL)
      uri.query = URI.encode_www_form(params.merge({ appid: api_key }))
      uri
    end

    def get_temperature(uri)
      response = Net::HTTP.get(uri)
      parsed_response = JSON.parse(response)

      handle_errors(parsed_response)

      @result.success = parsed_response['main']['temp'] if response_successful?(parsed_response)

      @result
    end

    def response_successful?(response)
      response['cod'] == HTTP_OK_CODE
    end

    def handle_errors(response)
      @result.errors << %i[city not_found] if response['cod'].to_i == HTTP_NOT_FOUND_CODE

      if response['cod'] == HTTP_UNAUTHORIZED_CODE
        @result.errors << %i[base something_went_wrong]
        raise 'unauthorized'
      end

      @result.errors << %i[city not_found] if response['message'] == 'Nothing to geocode'
    end
  end
end
