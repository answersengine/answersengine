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

      def self.exposed_methods
        [
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

      def update_to_server(opts = {})
        parsing_update(
          job_id: opts[:job_id],
          gid: opts[:gid],
          pages: opts[:pages],
          outputs: opts[:outputs],
          parsing_status: opts[:status])
      end

      def update_parsing_starting_status
        return unless save

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

      def update_parsing_done_status
        return unless save

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

      def save_type
        :parsing
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
            eval_with_context filename, context
          rescue SyntaxError => e
            handle_error(e) if save
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end

          puts "=========== Parsing Executed ==========="
          save_pages_and_outputs(pages, outputs, :parsing)
          update_parsing_done_status
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
          parsing_status: :failed,
          log_error: error)
      end

    end
  end
end
