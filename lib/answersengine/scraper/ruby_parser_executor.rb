module AnswersEngine
  module Scraper
    class RubyParserExecutor < Executor

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @gid = options.fetch(:gid) { raise "GID is required"}
        @job_id = options.fetch(:job_id)
        @page_vars = options.fetch(:vars) { {} }
      end

      def exec_parser(save=false)
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


      def eval_parser_script(save=false)
        proc = Proc.new do
          page = init_page
          outputs = []
          pages = []
          page = init_page_vars(page)

          begin

            eval(File.read(filename), binding, filename)
          rescue SyntaxError => e
            handle_error(e) if save 
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end

          puts "=========== Parsing Executed ==========="

          if save
            # puts "output to save: #{{job_id: job_id, gid: gid,outputs: outputs, pages: pages}} "
            response = parsing_update(
              job_id: job_id, 
              gid: gid,
              outputs: outputs, 
              pages: pages) 

            if response.code == 200
              puts "Job Page Status Updated."
            else
              puts "Error: Unable to save to server: #{response.body}"
            end
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
          log_error: error)
      end

    end
  end
end