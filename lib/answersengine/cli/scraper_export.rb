module AnswersEngine
  class CLI < Thor
    class ScraperExport < Thor
      package_name "scraper export"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "show <export_id>", "Show a scraper's export"
      def show(export_id)
        client = Client::ScraperExport.new(options)
        puts "#{client.find(export_id)}"
      end


      desc "list <scraper_name>", "Gets a list of exports on a scraper"
      long_desc <<-LONGDESC
        List exporters on a scraper.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list(scraper_name)
        client = Client::ScraperExport.new(options)
        puts "#{client.all(scraper_name)}"
      end

      desc "download <export_id>", "Download the exported file"
      def download(export_id)
        client = Client::ScraperExport.new(options)
        result = JSON.parse(client.download(export_id).to_s)
        
        if result['signed_url']
          puts "Download url: \"#{result['signed_url']}\""
          `open "#{result['signed_url']}"`
        else
          puts "Exported file does not exist"
        end        
      end



    end
  end

end
