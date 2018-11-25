module AnswersEngine
  class CLI < Thor
    class JobOutput < Thor

      package_name "scraper output"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "list <scraper_name>", "List output records in a collection that is in the current job"
      long_desc <<-LONGDESC
        List all output records in a collection that is in the current job of a scraper\n
      LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :collection, :aliases => :c, desc: "Shows outputs from a specific collection.(defaults to 'default' collection)"
      def list(scraper_name)
        collection = options.fetch(:collection) { 'default' }
        if options[:job]
          client = Client::JobOutput.new(options)
          puts "#{client.all(options[:job], collection)}"
        else
          client = Client::ScraperJobOutput.new(options)
          puts "#{client.all(scraper_name, collection)}"
        end
      end

      desc "show <scraper_name> <record_id>", "Show one output record in a collection that is in the current job of a scraper"
      long_desc <<-LONGDESC
        Shows an output record in a collection that is in the current job of a scraper\n
        <record_id>: ID of the output record.\x5
      LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      option :collection, :aliases => :c, desc: "Shows output from a specific collection.(defaults to 'default' collection)"
      def show(scraper_name, id)
        collection = options.fetch(:collection) { 'default' }
        if options[:job]
          client = Client::JobOutput.new(options)
          puts "#{client.find(options[:job], collection, id)}"
        else
          client = Client::ScraperJobOutput.new(options)
          puts "#{client.find(scraper_name, collection, id)}"
        end
      end

      desc "collections <scraper_name>", "list job output collections that are inside a current job of a scraper."
      long_desc <<-LONGDESC
        List job output collections that are inside a current job of a scraper.\x5
      LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      def collections(scraper_name)

        if options[:job]
          client = Client::JobOutput.new(options)
          puts "#{client.collections(options[:job])}"
        else
          client = Client::ScraperJobOutput.new(options)
          puts "#{client.collections(scraper_name)}"
        end
      end

    end
  end

end
