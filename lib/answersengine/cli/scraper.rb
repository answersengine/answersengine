module AnswersEngine
  class CLI < Thor
    class Scraper < Thor
      desc "list", "List scrapers"
      
      long_desc <<-LONGDESC
        List all scrapers.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list
        client = Client::Scraper.new(options)
        puts "#{client.all}"
      end

      desc "create <scraper_name> <git_repository>", "Create a scraper"
      long_desc <<-LONGDESC
          Creates a scraper\x5
          <scraper_name>: Scraper name can only consist of alphabets, numbers, underscores and dashes. Name must be unique to your account.\x5
          <git_repository>: URL to a valid Git repository.\x5
          LONGDESC
      option :branch, :aliases => :b, desc: 'Set the Git branch to use. Default: master'
      option :freshness_type, :aliases => :t, desc: 'Set how fresh the page cache is. Possible values: day, week, month, year. Default: any'
      option :proxy_type, desc: 'Set the Proxy type. Default: standard'
      option :force_fetch, :aliases => :f, type: :boolean, desc: 'Set true to force fetch page that is not within freshness criteria. Default: false'
      option :workers, :aliases => :w, type: :numeric, desc: 'Set how many standard workers to use. Default: 1'
      option :browsers, type: :numeric, desc: 'Set how many browser workers to use. Default: 0'
      option :disable_scheduler, type: :boolean, desc: 'Set true to disable scheduler. Default: false' 
      option :cancel_current_job, type: :boolean, desc: 'Set true to cancel currently active job if scheduler starts. Default: false' 
      option :schedule, type: :string, desc: 'Set the schedule of the scraper to run. Must be in CRON format.'
      option :timezone, type: :string, desc: "Set the scheduler's timezone. Must be in IANA Timezone format. Defaults to \"America/Toronto\""
      def create(scraper_name, git_repository)
        puts "options #{options}"
        client = Client::Scraper.new(options)
        puts "#{client.create(scraper_name, git_repository, options)}"
      end

      desc "update <scraper_name>", "Update a scraper"
      long_desc <<-LONGDESC
          Updates a scraper\x5
          LONGDESC
      option :branch, :aliases => :b, desc: 'Set the Git branch to use. Default: master'
      option :name, :aliases => :n, desc: 'Set the scraper name. Name can only consist of alphabets, numbers, underscores and dashes. Name must be unique to your account'
      option :repo, :aliases => :r, desc: 'Set the URL to a valid Git repository'
      option :freshness_type, :aliases => :t, desc: 'Set how fresh the page cache is. Possible values: day, week, month, year. Default: any'
      option :proxy_type, desc: 'Set the Proxy type. Default: standard'
      option :force_fetch, :aliases => :f, type: :boolean, desc: 'Set true to force fetch page that is not within freshness criteria. Default: false'
      option :workers, :aliases => :w, type: :numeric, desc: 'Set how many standard workers to use. Default: 1'
      option :browsers, type: :numeric, desc: 'Set how many browser workers to use. Default: 0'
      option :disable_scheduler, type: :boolean, desc: 'Set true to disable scheduler. Default: false' 
      option :cancel_current_job, type: :boolean, desc: 'Set true to cancel currently active job if scheduler starts. Default: false' 
      option :schedule, type: :string, desc: 'Set the schedule of the scraper to run. Must be in CRON format.'
      option :timezone, type: :string, desc: "Set the scheduler's timezone. Must be in IANA Timezone format. Defaults to \"America/Toronto\""
      def update(scraper_name)
        client = Client::Scraper.new(options)
        puts "#{client.update(scraper_name, options)}"
      end


      desc "show <scraper_name>", "Show a scraper"
      def show(scraper_name)
        client = Client::Scraper.new(options)
        puts "#{client.find(scraper_name)}"
      end

      desc "deploy <scraper_name>", "Deploy a scraper"
      long_desc <<-LONGDESC
          Deploys a scraper
          LONGDESC
      def deploy(scraper_name)
        client = Client::ScraperDeployment.new()
        puts "Deploying scraper. This may take a while..."
        puts "#{client.deploy(scraper_name)}"
      end

      desc "start <scraper_name>", "Creates a scraping job and runs it"
      long_desc <<-LONGDESC
          Starts a scraper by creating an active scrape job\x5
          LONGDESC
      option :workers, :aliases => :w, type: :numeric, desc: 'Set how many standard workers to use. Default: 1'
      option :browsers, type: :numeric, desc: 'Set how many browser workers to use. Default: 0'
      option :proxy_type, desc: 'Set the Proxy type. Default: standard'
      def start(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "Starting a scrape job..."
        puts "#{client.create(scraper_name, options)}"
      end


      desc "log <scraper_name>", "List log entries related to a scraper's current job"
      long_desc <<-LONGDESC
          Shows log related to a scraper's current job. Defaults to showing the most recent entries\x5
          LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      option :head, :aliases => :H, desc: 'Show the oldest log entries. If not set, newest entries is shown'
      option :parsing, :aliases => :p, type: :boolean, desc: 'Show only log entries related to parsing'
      option :seeding, :aliases => :s, type: :boolean, desc: 'Show only log entries related to seeding'
      option :verbose, :aliases => :v, type: :boolean, desc: 'Show all log entries including fetching, seeding, parsing, etc'
      option :more, :aliases => :m, desc: 'Show next set of log entries. Enter the `More token`'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 5000 per page.'
      def log(scraper_name)
        client = Client::JobLog.new(options)

        query = {}
        query["order"] = options.delete(:head) if options[:head]
        query["job_type"] = "parsing" if options[:parsing]
        query["job_type"] = "seeding" if options[:seeding]
        query["job_type"] = "verbose" if options[:verbose]
        query["page_token"] = options.delete(:more) if options[:more]
        query["per_page"] = options.delete(:per_page) if options[:per_page]

        if options[:job]
          result = client.all_job_log(options[:job], {query: query})
        else
          result = client.scraper_all_job_log(scraper_name, {query: query})
        end

        unless result["entries"].nil?

          more_token = result["more_token"]

          result["entries"].each do |entry|
            puts "#{entry["timestamp"]} #{entry["severity"]}: #{entry["payload"]}" if entry.is_a?(Hash)
          end

          unless more_token == ""
            puts "-----------"
            puts "To see more entries, add: \"--more #{more_token}\""
          end
        end
      end

      desc "stats <scraper_name>", "Get the current stat for a job"
      long_desc <<-LONGDESC
        Get stats for a scraper's current job\n
      LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      def stats(scraper_name)
        client = Client::JobStat.new(options)
        if options[:job]
          puts "#{client.job_current_stats(options[:job])}"
        else
          puts "#{client.scraper_job_current_stats(scraper_name)}"
        end

      end


      desc "job SUBCOMMAND ...ARGS", "manage scrapers jobs"
      subcommand "job", ScraperJob

      desc "deployment SUBCOMMAND ...ARGS", "manage scrapers deployments"
      subcommand "deployment", ScraperDeployment

      desc "output SUBCOMMAND ...ARGS", "view scraper outputs"
      subcommand "output", JobOutput

      desc "page SUBCOMMAND ...ARGS", "manage pages on a job"
      subcommand "page", ScraperPage

    end
  end

end
