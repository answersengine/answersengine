module AnswersEngine
  class CLI < Thor
    class ScraperJob < Thor
      package_name "scraper job"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "show <scraper_name>", "Show a scraper's current job"
      def show(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.find(scraper_name)}"
      end


      desc "list <scraper_name>", "gets a list of jobs on a scraper"
      long_desc <<-LONGDESC
        List jobs on a scraper.
      LONGDESC
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      def list(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.all(scraper_name)}"
      end


      desc "cancel <scraper_name>", "cancels a scraper's current job"
      long_desc <<-LONGDESC
        Cancels a scraper's current job
      LONGDESC
      def cancel(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.cancel(scraper_name)}"
      end

      desc "resume <scraper_name>", "resumes a scraper's current job"
      long_desc <<-LONGDESC
        Resumes a scraper's current job
      LONGDESC
      def resume(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.resume(scraper_name)}"
      end

      desc "pause <scraper_name>", "pauses a scraper's current job"
      long_desc <<-LONGDESC
        pauses a scraper's current job
      LONGDESC
      def pause(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.pause(scraper_name)}"
      end


      desc "update <scraper_name>", "updates a scraper's current job"
      long_desc <<-LONGDESC
        Updates a scraper's current job.
      LONGDESC
      option :workers, :aliases => :w, type: :numeric, desc: 'Set how many workers to use. Scraper job must be restarted(paused then resumed, or cancelled then resumed) for it to take effect. Default: 1. '
      def update(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.update(scraper_name, options)}"
      end

    end
  end

end
