module AnswersEngine
  class CLI < Thor
    class Job < Scraper
      desc "<scraper_id> jobs", "gets a list of jobs"
      option :page, :aliases => :p
          long_desc <<-LONGDESC
            List scrapers.
       
            With --page or -p option to get the next set of records by page.
          LONGDESC
      def list(scraper_id)
        # puts AnswersEngine::Scraper:(scraper_id)
        puts "hello"
      end

      
    end
  end

end
