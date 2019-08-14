module AnswersEngine
  module Scraper
    class Finisher

      def self.exec_finisher(filename, job_id=nil, save=false)
        extname = File.extname(filename)
        case extname
        when '.rb'
          executor = RubyFinisherExecutor.new(filename: filename, job_id: job_id)
          executor.exec_finisher(save)
        else
          puts "Unable to find a finisher executor for file type \"#{extname}\""
        end
      end

    end
  end
end
