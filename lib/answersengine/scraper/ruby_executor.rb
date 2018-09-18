module AnswersEngine
  module Scraper
    class RubyExecutor < Executor

      def execute_global_page_parser
        try_script_on_global_page
      end
      
      def try_script_on_global_page
        proc = Proc.new do
          page = init_page(gid: gid)
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