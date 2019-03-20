require 'nokogiri'
module AnswersEngine
  module Scraper
    # @abstract
    class Executor
      # Max allowed page size when query outputs (see #find_outputs).
      MAX_FIND_OUTPUTS_PER_PAGE = 500

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

      # Get current job id from scraper or default when scraper_name is null.
      #
      # @param [String|nil] scraper_name Scraper name.
      # @param [Integer|nil] default (nil) Default job id when no scraper name.
      #
      # @raise [Exception] When scraper name is not null, and scraper doesn't
      #   exists or it has no current job.
      def get_job_id scraper_name, default = nil
        return default if scraper_name.nil?
        job = Client::ScraperJob.new().find(scraper_name)
        raise JSON.pretty_generate(job) if job['id'].nil?
        job['id']
      end

      # Find outputs by collection and query with pagination.
      #
      # @param [String] collection ('default') Collection name.
      # @param [Hash] query ({}) Filters to query.
      # @param [Integer] page (1) Page number.
      # @param [Integer] per_page (30) Page size.
      # @param [Hash] opts ({}) Configuration options.
      # @option opts [String|nil] :scraper_name (nil) Scraper name to query
      #   from.
      # @option opts [Integer|nil] :job_id (nil) Job's id to query from.
      #
      # @raise [ArgumentError] +collection+ is not String.
      # @raise [ArgumentError] +query+ is not a Hash.
      # @raise [ArgumentError] +page+ is not an Integer greater than 0.
      # @raise [ArgumentError] +per_page+ is not an Integer between 1 and 500.
      #
      # @return [Array]
      #
      # @example
      #   find_outputs
      # @example
      #   find_outputs 'my_collection'
      # @example
      #   find_outputs 'my_collection', {}
      # @example
      #   find_outputs 'my_collection', {}, 1
      # @example
      #   find_outputs 'my_collection', {}, 1, 30
      # @example Find from another scraper by name
      #   find_outputs 'my_collection', {}, 1, 30, scraper_name: 'my_scraper'
      # @example Find from another scraper by job_id
      #   find_outputs 'my_collection', {}, 1, 30, job_id: 123
      #
      # @note *opts `:job_id` option is prioritize over `:scraper_name` when
      #   both exists. If none add provided or nil values, then current job
      #   will be used to query instead, this is the defaul behavior.
      def find_outputs(collection='default', query={}, page=1, per_page=30, opts = {})
        # Validate parameters out from nil for easier user usage.
        raise ArgumentError.new("collection needs to be a String") unless collection.is_a?(String)
        raise ArgumentError.new("query needs to be a Hash, instead of: #{query}") unless query.is_a?(Hash)
        unless page.is_a?(Integer) && page > 0
          raise ArgumentError.new("page needs to be an Integer greater than 0")
        end
        unless per_page.is_a?(Integer) && per_page > 0 && per_page <= MAX_FIND_OUTPUTS_PER_PAGE
          raise ArgumentError.new("per_page needs to be an Integer between 1 and #{MAX_FIND_OUTPUTS_PER_PAGE}")
        end

        options = {
          query: query,
          page: page,
          per_page: per_page}

        # Get job_id
        query_job_id = opts[:job_id] || get_job_id(opts[:scraper_name], self.job_id)

        client = Client::JobOutput.new(options)
        response = client.all(query_job_id, collection)

        if response.code != 200
          raise "response_code: #{response.code}|#{response.parsed_response}"
        end
        (response.body != 'null') ? response.parsed_response : []
      end

      # Find one output by collection and query with pagination.
      #
      # @param [String] collection ('default') Collection name.
      # @param [Hash] query ({}) Filters to query.
      # @param [Hash] opts ({}) Configuration options.
      # @option opts [String|nil] :scraper_name (nil) Scraper name to query
      #   from.
      # @option opts [Integer|nil] :job_id (nil) Job's id to query from.
      #
      # @raise [ArgumentError] +collection+ is not String.
      # @raise [ArgumentError] +query+ is not a Hash.
      #
      # @return [Hash|nil] `Hash` when found, and `nil` when no output is found.
      #
      # @example
      #   find_output
      # @example
      #   find_output 'my_collection'
      # @example
      #   find_output 'my_collection', {}
      # @example Find from another scraper by name
      #   find_output 'my_collection', {}, scraper_name: 'my_scraper'
      # @example Find from another scraper by job_id
      #   find_output 'my_collection', {}, job_id: 123
      #
      # @note *opts `:job_id` option is prioritize over `:scraper_name` when
      #   both exists. If none add provided or nil values, then current job
      #   will be used to query instead, this is the defaul behavior.
      def find_output(collection='default', query={}, opts = {})
        result = find_outputs(collection, query, 1, 1, opts)
        result.respond_to?(:first) ? result.first : nil
      end

      # Remove dups by prioritizing the latest dup.
      #
      # @param [Array] list List of hashes to dedup.
      # @param [Hash] key_defaults Key and default value pair hash to use on
      #   uniq validation.
      #
      # @return [Integer] Removed duplicated items count.
      def remove_old_dups!(list, key_defaults)
        raw_count = list.count
        keys = key_defaults.keys
        list.reverse!.uniq! do |item|
          # Extract stringify keys as hash
          key_hash = Hash[item.map{|k,v|keys.include?(k.to_s) ? [k.to_s,v] : nil}.select{|i|!i.nil?}]

          # Apply defaults for uniq validation
          key_defaults.each{|k,v| key_hash[k] = v if key_hash[k].nil?}
          key_hash
        end
        list.reverse!
        dup_count = raw_count - list.count
        dup_count
      end

      # Remove page dups by prioritizing the latest dup.
      #
      # @param [Array] list List of pages to dedup.
      #
      # @return [Integer] Removed duplicated items count.
      #
      # @note It will not dedup for now as it is hard to build gid.
      #   TODO: Build gid so we can dedup
      def remove_old_page_dups!(list)
        # key_defaults = {
        #   'gid' => nil
        # }
        # remove_old_dups! list, key_defaults
        0
      end

      # Remove dups by prioritizing the latest dup.
      #
      # @param [Array] list List of outputs to dedup.
      #
      # @return [Integer] Removed duplicated items count.
      def remove_old_output_dups!(list)
        key_defaults = {
          '_id' => nil,
          '_collection' => 'default'
        }
        remove_old_dups! list, key_defaults
      end

      def save_pages_and_outputs(pages = [], outputs = [], status)
        total_pages = pages.count
        total_outputs = outputs.count
        records_per_slice = 100
        until pages.empty? && outputs.empty?
          pages_slice = pages.shift(records_per_slice)
          pages_dup_count = remove_old_page_dups! pages_slice
          outputs_slice = outputs.shift(records_per_slice)
          outputs_dup_count = remove_old_output_dups! outputs_slice

          log_msgs = []
          unless pages_slice.empty?
            page_dups_ignored = pages_dup_count > 0 ? " (#{pages_dup_count} dups ignored)" : ''
            log_msgs << "#{pages_slice.count} out of #{total_pages} Pages#{page_dups_ignored}"
            unless save
              puts '----------------------------------------'
              puts "Would have saved #{log_msgs.last}#{page_dups_ignored}"
              puts JSON.pretty_generate pages_slice
            end
          end

          unless outputs_slice.empty?
            output_dups_ignored = outputs_dup_count > 0 ? " (#{outputs_dup_count} dups ignored)" : ''
            log_msgs << "#{outputs_slice.count} out of #{total_outputs} Outputs#{output_dups_ignored}"
            unless save
              puts '----------------------------------------'
              puts "Would have saved #{log_msgs.last}#{output_dups_ignored}"
              puts JSON.pretty_generate outputs_slice
            end
          end

          next unless save
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

      def save_type
        raise NotImplementedError.new('Need to implement "save_type" method.')
      end

      # Saves pages from an array and clear it.
      #
      # @param [Array] pages ([]) Page array to save. Warning: all elements will
      #   be removed from the array.
      #
      # @note IMPORTANT: +pages+ array's elements will be removed.
      def save_pages(pages=[])
        save_pages_and_outputs(pages, [], save_type)
      end

      # Saves outputs from an array and clear it.
      #
      # @param [Array] outputs ([]) Output array to save. Warning: all elements
      #   will be removed from the array.
      #
      # @note IMPORTANT: +outputs+ array's elements will be removed.
      def save_outputs(outputs=[])
        save_pages_and_outputs([], outputs, save_type)
      end

      # Eval a filename with a custom binding
      #
      # @param [String] file_path File path to read.
      # @param [Binding] context Context binding to evaluate with.
      #
      # @note Using this method will allow scripts to contain `return` to
      #   exit the script sooner along some improved security.
      def eval_with_context file_path, context
        eval(File.read(file_path), context, file_path)
      end
    end
  end
end
