module AnswersEngine
  class CLI < Thor
    class ScraperJob < Thor
      package_name "scraper job"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end


      desc "list <scraper_id>", "gets a list of jobs on a scraper"
      option :page, :aliases => :p
          long_desc <<-LONGDESC
            List jobs on a scraper.
       
            With --page or -p option to get the next set of records by page.
          LONGDESC
      def list(scraper_id)
        client = Client::ScraperJob.new(options)
        puts "#{client.all(scraper_id)}"
      end
      
    end
  end

end
