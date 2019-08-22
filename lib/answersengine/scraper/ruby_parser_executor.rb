module AnswersEngine
  module Scraper
    class RubyParserExecutor < Executor
      attr_accessor :save
      # Refetch self page flag.
      # @return [Boollean]
      # @nore It is stronger than #reparse_self flag.
      attr_accessor :refetch_self
      # Reparse self page flag.
      # @return [Boollean]
      attr_accessor :reparse_self

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
          :find_outputs,
          :refetch,
          :reparse
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

      def refetch_page gid
        if save
          Client::ScraperJobPage.new({gid: gid}).refetch_by_job(self.job_id)
          puts "Refetch page #{gid}"
        else
          puts "Would have refetch page #{gid}"
        end
      end

      def refetch page_gid
        raise ArgumentError.new("page_gid needs to be a String.") unless page_gid.is_a?(String)
        if page_gid == gid
          self.refetch_self = true
          return
        end
        refetch_page page_gid
      end

      def reparse_page gid
        if save
          Client::ScraperJobPage.new({gid: gid}).reparse_by_job(self.job_id)
          puts "Reparse page #{gid}"
        else
          puts "Would have reparse page #{gid}"
        end
      end

      def reparse page_gid
        raise ArgumentError.new("page_gid needs to be a String.") unless page_gid.is_a?(String)
        if page_gid == gid
          self.reparse_self = true
          return
        end
        reparse_page page_gid
      end

      def eval_parser_script(save=false)
        update_parsing_starting_status

        proc = Proc.new do
          page = init_page
          outputs = []
          pages = []
          page = init_page_vars(page)
          self.refetch_self = false
          self.reparse_self = false

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
          if refetch_self
            refetch_page gid
          elsif reparse_self
            reparse_page gid
          else
            update_parsing_done_status
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
          parsing_status: :failed,
          log_error: error)
      end

    end
  end
end
