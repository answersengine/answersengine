require 'nokogiri'
module AnswersEngine
  module Scraper
    class Executor
      attr_accessor :filename, :gid, :job_id


      def exec_parser(save=false)
        raise "should be implemented in subclass"
      end

      def init_page()
        if job_id 
          puts "getting Job Page"
          init_job_page
        else
          puts "getting Global Page"
          init_global_page() 
        end
        
      end

      def init_job_page()
        client = Client::JobPage.new()
        job_page = client.find(job_id, gid)
        unless job_page.code == 200
          raise "Job #{job_id} or GID #{gid} not found. Aborting execution!"
        else
          job_page
        end
        
      end

      def parsing_update(options={})
        client = Client::JobPage.new()
        job_id = options.fetch(:job_id)
        gid = options.fetch(:gid)

        client.parsing_update(job_id, gid, options)
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