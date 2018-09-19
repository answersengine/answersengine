require 'nokogiri'
module AnswersEngine
  module Scraper
    class Executor
      attr_accessor :filename, :gid, :job_id


      def try_parser
        raise "should be implemented in subclass"
      end

      def init_page()
        if job_id 
          puts "job_page is called"
          init_job_page
        else
          puts "global_page is called"
          init_global_page() 
        end
        
      end

      def init_job_page()
        client = Client::JobPage.new()
        client.find(job_id, gid)
      end

      def init_global_page()
        client = Client::GlobalPage.new()
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