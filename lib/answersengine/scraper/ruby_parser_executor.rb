module AnswersEngine
  module Scraper
    class RubyParserExecutor < Executor

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @gid = options.fetch(:gid) { raise "GID is required"}
        @job_id = options.fetch(:job_id)
      end


      def try_parser
        try_parser_script
      end

      def try_parser_script
        proc = Proc.new do
          page = init_page
          outputs = []
          pages = []
          content = get_content(gid)
          
          eval(File.read(filename), binding, filename)

          puts "=========== Parsing Done Successfully ==========="

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

    end
  end
end