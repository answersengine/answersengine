module AnswersEngine
  class CLI < Thor
    class Job < Thor
      package_name "scraper job"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end


      desc "list <scraper_id>", "gets a list of jobs of scraper"
      option :page, :aliases => :p
          long_desc <<-LONGDESC
            List scrape jobs.
       
            With --page or -p option to get the next set of records by page.
          LONGDESC
      def list(scraper_id)
        # puts AnswersEngine::Scraper:(scraper_id)
        puts "hello"
      end

      
    end
  end

end
