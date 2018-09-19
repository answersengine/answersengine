module AnswersEngine
  module Scraper
    class RubyExecutor < Executor

      def try_parser
        try_script
      end
      
      def try_script
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