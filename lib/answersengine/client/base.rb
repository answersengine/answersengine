require 'httparty'

module AnswersEngine
  module Client
    class Base
      include HTTParty

      def self.env_auth_token
        ENV['ANSWERSENGINE_TOKEN']
      end

      def env_api_url
        ENV['ANSWERSENGINE_API_URL'].nil? ? 'https://fetch.answersengine.com/api/v1' : ENV['ANSWERSENGINE_API_URL']
      end

      def auth_token
        @auth_token ||= self.class.env_auth_token
      end

      def auth_token= value
        @auth_token = value
      end

      def initialize(opts={})
        self.class.base_uri(env_api_url)
        self.auth_token = opts[:auth_token] unless opts[:auth_token].nil?
        @options = { headers: {
          "Authorization" => "Bearer #{auth_token}",
          "Content-Type" => "application/json",
          }}

        query = {}
        query[:p] = opts[:page] if opts[:page]
        query[:pp] = opts[:per_page] if opts[:per_page]
        query[:fetchfail] = opts[:fetch_fail] if opts[:fetch_fail]
        query[:parsefail] = opts[:parse_fail] if opts[:parse_fail]
        query[:status] = opts[:status] if opts[:status]
        query[:page_type] = opts[:page_type] if opts[:page_type]
        query[:gid] = opts[:gid] if opts[:gid]

        if opts[:query]
          if opts[:query].is_a?(Hash)
            query[:q] = opts[:query].to_json
          elsif opts[:query].is_a?(String)
            query[:q] = JSON.parse(opts[:query]).to_json
          end
        end

        unless query.empty?
          @options.merge!(query: query)
        end
      end
    end
  end
end
