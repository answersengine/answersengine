module AnswersEngine
  module Scraper
    class Parser
      def self.try_parser_page(filename, gid, job_id=nil)
        extname = File.extname(filename)
        case extname
        when '.rb'
          executor = RubyParserExecutor.new(filename: filename, gid: gid, job_id: job_id)
          executor.try_parser
        else
          puts "Unable to find a parser executor for file type \"#{extname}\""
        end
      end

    end
  end
end