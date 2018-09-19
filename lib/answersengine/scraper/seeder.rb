module AnswersEngine
  module Scraper
    class Seeder
      def self.try_seeder(filename)
        extname = File.extname(filename)
        case extname
        when '.rb'
          executor = RubySeederExecutor.new(filename: filename)
          executor.try_seeder
        else
          puts "Unable to find a seeder executor for file type \"#{extname}\""
        end
      end

    end
  end
end