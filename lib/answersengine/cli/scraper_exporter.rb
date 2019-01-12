module AnswersEngine
  class CLI < Thor
    class ScraperExporter < Thor
      package_name "scraper exporter"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "show <scraper_name> <exporter_name>", "Show a scraper's exporter"
      def show(scraper_name, exporter_name)
        client = Client::ScraperExporter.new(options)
        puts "#{client.find(scraper_name, exporter_name)}"
      end


      desc "list <scraper_name>", "gets a list of exporters on a scraper"
      long_desc <<-LONGDESC
        List exporters on a scraper.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list(scraper_name)
        client = Client::ScraperExporter.new(options)
        puts "#{client.all(scraper_name)}"
      end
    end
  end

end
