module AnswersEngine
  class CLI < Thor
    class ScraperDeployment < Thor

      package_name "scraper deployment"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      
      desc "list <scraper_name>", "List deployments on a scraper"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        List deployments on a scraper.
   
        With --page or -p option to get the next set of records by page.
      LONGDESC
      def list(scraper_name)
        client = Client::ScraperDeployment.new(options)
        puts "#{client.all(scraper_name)}"
      end
    end
  end

end
