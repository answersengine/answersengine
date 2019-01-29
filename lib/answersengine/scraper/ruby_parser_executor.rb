module AnswersEngine
  module Scraper
    class RubyParserExecutor < Executor
      attr_accessor :save

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @gid = options.fetch(:gid) { raise "GID is required"}
        @job_id = options.fetch(:job_id)
        @page_vars = options.fetch(:vars) { {} }
      end

      def exposed_methods
        @exposed_methods ||= [
          :content,
          :failed_content,
          :outputs,
          :pages,
          :page,
          :save_pages,
          :save_outputs,
          :find_output,
          :find_outputs
        ].freeze
      end

      def exec_parser(save=false)
        @save = save
        if save
          puts "Executing parser script"
        else
          puts "Trying parser script"
        end

        eval_parser_script(save)
      end

      def init_page_vars(page)
        if !@page_vars.nil? && !@page_vars.empty?
          page['vars'] = @page_vars
        end
        page
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

      def save_pages_and_outputs(pages = [], outputs = [], parsing_status = :parsing)
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
            response = parsing_update(
              job_id: job_id,
              gid: gid,
              pages: pages_slice,
              outputs: outputs_slice,
              parsing_status: parsing_status)

            if response.code == 200
              log_msg = "Saved."
              puts "#{log_msg}"
            else
              puts "Error: Unable to save Pages and/or Outputs to server: #{response.body}"
              raise "Unable to save Pages and/or Outputs to server: #{response.body}"
            end
          end
      end

      def update_parsing_starting_status
        if save
          response = parsing_update(
            job_id: job_id,
            gid: gid,
            parsing_status: :starting)

          if response.code == 200
            puts "Page Parsing Status Updated."
          else
            puts "Error: Unable to save Page Parsing Status to server: #{response.body}"
            raise "Unable to save Page Parsing Status to server: #{response.body}"
          end
        end
      end

      def update_parsing_done_status
        if save
          response = parsing_update(
            job_id: job_id,
            gid: gid,
            parsing_status: :done)

          if response.code == 200
            puts "Page Parsing Done."
          else
            puts "Error: Unable to save Page Parsing Done Status to server: #{response.body}"
            raise "Unable to save Page Parsing Done Status to server: #{response.body}"
          end
        end
      end

      def save_pages(pages=[])
        if save
          save_pages_and_outputs(pages, [], :parsing)
        end
      end 

      def save_outputs(outputs=[])
        if save
          save_pages_and_outputs([], outputs, :parsing)
        end
      end 

      def eval_parser_script(save=false)
        update_parsing_starting_status

        proc = Proc.new do
          page = init_page
          outputs = []
          pages = []
          page = init_page_vars(page)

          begin
            context = isolated_binding({
              outputs: outputs,
              pages: pages,
              page: page
            })
            eval(File.read(filename), context, filename)
          rescue SyntaxError => e
            handle_error(e) if save
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end

          puts "=========== Parsing Executed ==========="

          if save
            save_pages_and_outputs(pages, outputs)
            update_parsing_done_status
          end

          unless outputs.empty?
            puts "----------- Outputs: -----------"
            puts JSON.pretty_generate(outputs)
          end

          unless pages.empty?
            puts "----------- New Pages to Enqueue: -----------"
            puts JSON.pretty_generate(pages)

          end
        end
        proc.call
      end

      def content
        @content ||= get_content(gid)
      end

      def failed_content
        @failed_content ||= get_failed_content(gid)
      end

      def handle_error(e)
        error = ["Parsing #{e.class}: #{e.to_s} (Job:#{job_id} GID:#{gid})",clean_backtrace(e.backtrace)].join("\n")

        parsing_update(
          job_id: job_id,
          gid: gid,
          parsing_failed: true,
          parsing_status: "failed",
          log_error: error)
      end

    end
  end
end
