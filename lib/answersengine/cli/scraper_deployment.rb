module AnswersEngine
  class CLI < Thor
    class ScraperDeployment < Thor

      package_name "scraper deployment"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      
      desc "list <scraper_id>", "List deployments on a scraper"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        List deployments on a scraper.
   
        With --page or -p option to get the next set of records by page.
      LONGDESC
      def list(scraper_id)
        client = Client::ScraperDeployment.new(options)
        puts "#{client.all(scraper_id)}"
      end
    end
  end

end
