require 'nokogiri'
module AnswersEngine
  module Scraper
    class Executor
      attr_accessor :filename, :gid, :job_id

      include AnswersEngine::Plugin::ContextExposer

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

      def seeding_update(options={})
        client = Client::Job.new()
        job_id = options.fetch(:job_id)

        client.seeding_update(job_id, options)
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
          Client::BackblazeContent.new.get_gunzipped_content(signed_url)
        else
          nil
        end
      end

      def get_failed_content(gid)
        client = Client::GlobalPage.new()
        content_json = client.find_failed_content(gid)

        if content_json['available']
          signed_url = content_json['signed_url']
          Client::BackblazeContent.new.get_gunzipped_content(signed_url)
        else
          nil
        end
      end

      def find_outputs(collection='default', query={}, page=1, per_page=30)
        raise "query needs to be a Hash, instead of: #{query}" unless query.is_a?(Hash)

        options = {
          query: query,
          page: page,
          per_page: per_page}

        client = Client::JobOutput.new(options)
        response = client.all(job_id, collection)

        if response.code == 200 && response.body != 'null'
          response
        else
          []
        end
      end

      def find_output(collection='default', query={})
        result = find_outputs(collection, query, 1, 1)
        result.first if result.respond_to?(:first)
      end

      def save_pages_and_outputs(pages = [], outputs = [], status)
        total_pages = pages.count
        total_outputs = outputs.count
        records_per_slice = 100
        until pages.empty? && outputs.empty?
          pages_slice = pages.shift(records_per_slice)
          outputs_slice = outputs.shift(records_per_slice)

          log_msgs = []
          unless pages_slice.empty?
            log_msgs << "#{pages_slice.count} out of #{total_pages} Pages"
          end

          unless outputs_slice.empty?
            log_msgs << "#{outputs_slice.count} out of #{total_outputs} Outputs"
          end

          log_msg = "Saving #{log_msgs.join(' and ')}."
          puts "#{log_msg}"

          # saving to server
          response = update_to_server(
            job_id: job_id,
            gid: gid,
            pages: pages_slice,
            outputs: outputs_slice,
            status: status)

          if response.code == 200
            log_msg = "Saved."
            puts "#{log_msg}"
          else
            puts "Error: Unable to save Pages and/or Outputs to server: #{response.body}"
            raise "Unable to save Pages and/or Outputs to server: #{response.body}"
          end
        end
      end

      def update_to_server(opts = {})
        raise "Implemented in Subclass"
      end

      def clean_backtrace(backtrace)
        i = backtrace.index{|x| x =~ /gems\/answersengine/i}
        if i.to_i < 1
          return []
        else
          return backtrace[0..(i-1)]
        end
      end
    end
  end
end
