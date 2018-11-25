module AnswersEngine
  class CLI < Thor
    class ScraperJob < Thor
      package_name "scraper job"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end


      desc "list <scraper_name>", "gets a list of jobs on a scraper"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        List jobs on a scraper.
   
        With --page or -p option to get the next set of records by page.
      LONGDESC
      def list(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "#{client.all(scraper_name)}"
      end


      desc "cancel <job_id>", "cancels a job"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        Cancels a job
      LONGDESC
      def cancel(job_id)
        client = Client::Job.new(options)
        puts "#{client.cancel(job_id)}"
      end

      desc "resume <job_id>", "resumes a job"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        Resumes a job
      LONGDESC
      def resume(job_id)
        client = Client::Job.new(options)
        puts "#{client.resume(job_id)}"
      end

      desc "pause <job_id>", "pauses a job"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        pauses a job
      LONGDESC
      def pause(job_id)
        client = Client::Job.new(options)
        puts "#{client.pause(job_id)}"
      end


      desc "update <job_id>", "updates a job"
      long_desc <<-LONGDESC
        Updates a job. You must cancel(or stop or pause) the job and then resume it, in order for it to take effect.\x5
          With --workers or -w option to set how many workers to use. Defaults to 1.
      LONGDESC
      option :workers, :aliases => :w, type: :numeric
      def update(job_id)
        client = Client::Job.new(options)
        puts "#{client.update(job_id, options)}"
      end
      
    end
  end

end
