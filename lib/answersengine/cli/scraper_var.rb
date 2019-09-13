module AnswersEngine
  class CLI < Thor
    class ScraperVar < Thor

      package_name "scraper var"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "list <scraper_name>", "List environment variables on the scraper"
      long_desc <<-LONGDESC
        List all environment variables on the scraper.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list(scraper_name)
        client = Client::ScraperVar.new(options)
        puts "#{client.all(scraper_name)}"
      end

      desc "set <scraper_name> <var_name> <value>", "Set an environment var on the scraper"
      long_desc <<-LONGDESC
          Creates an environment variable\x5
          <var_name>: Var name can only consist of alphabets, numbers, underscores. Name must be unique to your scraper, otherwise it will be overwritten.\x5
          <value>: Value of variable.\x5
          LONGDESC
      option :secret, type: :boolean, desc: 'Set true to make it decrypt the value. Default: false' 
      def set(scraper_name, var_name, value)
        # puts "options #{options}"
        client = Client::ScraperVar.new(options)
        puts "#{client.set(scraper_name, var_name, value, options)}"
      end

      desc "show <scraper_name> <var_name>", "Show an environment variable on the scraper"
      def show(scraper_name, var_name)
        client = Client::ScraperVar.new(options)
        puts "#{client.find(scraper_name, var_name)}"
      end

      desc "unset <scraper_name> <var_name>", "Deletes an environment variable on the scraper"
      def unset(scraper_name, var_name)
        client = Client::ScraperVar.new(options)
        puts "#{client.unset(scraper_name, var_name)}"
      end
    end
  end

end
