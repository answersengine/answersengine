module AnswersEngine
  module Scraper
    class Page
      attr_accessor :signed_content_url, :content, :gid, :hostname
      
      def initialize(options={})
        @gid = options.fetch(:gid) { raise "GID is required" }
        @signed_content_url = "signed content url here"
        @hostname = options.fetch(:hostname)
      end

      def content
        @content ||= "some content"
      end
    end
  end
end