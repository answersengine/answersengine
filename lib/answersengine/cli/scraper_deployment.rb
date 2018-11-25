module AnswersEngine
  class CLI < Thor
    class ScraperDeployment < Thor

      package_name "scraper deployment"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      
      desc "list <scraper_name>", "List deployments on a scraper"
      long_desc <<-LONGDESC
        List deployments on a scraper.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      def list(scraper_name)
        client = Client::ScraperDeployment.new(options)
        puts "#{client.all(scraper_name)}"
      end
    end
  end

end
