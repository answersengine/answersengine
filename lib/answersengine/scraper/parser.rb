module AnswersEngine
  module Scraper
    class Parser
      def self.parse_global_page(filename, gid)
        extname = File.extname(filename)
        case extname
        when '.rb'
          executor = RubyExecutor.new(filename: filename, gid: gid)
          executor.execute_global_page_parser
        else
          puts "Unable to find a parser executor for file type \"#{extname}\""
        end
      end
    end
  end
end