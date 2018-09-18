require 'nokogiri'
module AnswersEngine
  module Scraper
    class Executor
      attr_accessor :filename, :gid

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @gid = options.fetch(:gid) { raise "GID is required"}
      end

      def execute_global_page_parser
        raise "should be implemented in subclass"
      end

      def init_page(options={})
        client = Client::GlobalPage.new(options)
        client.find(gid)
      end

      def get_content(gid)
        client = Client::GlobalPage.new()
        content_json = client.find_content(gid)

        if content_json['available']
          signed_url = content_json['signed_url']
          Client::GCSContent.new.get_content(signed_url)
        else
          nil
        end
      end
    end
  end
end