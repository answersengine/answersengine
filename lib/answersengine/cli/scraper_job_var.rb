module AnswersEngine
  class CLI < Thor
    class ScraperJobVar < Thor

      package_name "job var"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} scraper #{@package_name} #{command.usage}"
      end

      desc "list <scraper_name>", "List environment variables on the scrape job"
      long_desc <<-LONGDESC
        List all environment variables on the scrape job.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list(scraper_name)
        client = Client::ScraperJobVar.new(options)
        puts "#{client.all(scraper_name)}"
      end

      desc "set <scraper_name> <var_name> <value>", "Set an environment var on the scrape job"
      long_desc <<-LONGDESC
          Creates an environment variable\x5
          <var_name>: Var name can only consist of alphabets, numbers, underscores. Name must be unique to your scrape job, otherwise it will be overwritten.\x5
          <value>: Value of variable.\x5
          LONGDESC
      option :secret, type: :boolean, desc: 'Set true to make it decrypt the value. Default: false' 
      def set(scraper_name, var_name, value)
        # puts "options #{options}"
        client = Client::ScraperJobVar.new(options)
        puts "#{client.set(scraper_name, var_name, value, options)}"
      end

      desc "show <scraper_name> <var_name>", "Show an environment variable on the scrape job"
      def show(scraper_name, var_name)
        client = Client::ScraperJobVar.new(options)
        puts "#{client.find(scraper_name, var_name)}"
      end

      desc "unset <scraper_name> <var_name>", "Deletes an environment variable on the scrape job"
      def unset(scraper_name, var_name)
        client = Client::ScraperJobVar.new(options)
        puts "#{client.unset(scraper_name, var_name)}"
      end
    end
  end

end
