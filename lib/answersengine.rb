require "datahen"

# Override env variables methods to include `ANSWERSENGINE_*` env variables
module Datahen
  module Client
    class Base
      def self.env_auth_token
        ENV['DATAHEN_TOKEN'].nil? ? ENV['ANSWERSENGINE_TOKEN'] : ENV['DATAHEN_TOKEN']
      end

      def env_api_url
        return ENV['DATAHEN_API_URL'] unless ENV['DATAHEN_API_URL'].nil?
        ENV['ANSWERSENGINE_API_URL'].nil? ? 'https://app.datahen.com/api/v1' : ENV['ANSWERSENGINE_API_URL']
      end
    end
  end
end

ENV['ANSWERSENGINE_TOKEN'] = ENV['DATAHEN_TOKEN'] if ENV['ANSWERSENGINE_TOKEN'].to_s.strip == ''

# (Deprecated) Alias to Datahen module.
AnswersEngine = ::Datahen
