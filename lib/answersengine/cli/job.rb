module AnswersEngine
  class CLI < Thor
    class Job < Thor
      package_name "job"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end


      desc "list", "gets a list of jobs"
      option :page, :aliases => :p
          long_desc <<-LONGDESC
            List scrape jobs.
       
            With --page or -p option to get the next set of records by page.
          LONGDESC
      def list()
        client = Client::Job.new(options)
        puts "#{client.all()}"
      end

      desc "show <job_id>", "Show a job"
      def show(job_id)
        client = Client::Job.new(options)
        puts "#{client.find(job_id)}"
      end

      desc "log <job_id>", "List log entries related to a Job"
      long_desc <<-LONGDESC
          Shows log related to the job. Defaults to showing the most recent entries\x5
          With --head or -H option to show the oldest log entries.\x5
          With --parsing or -p option to show only parsing log entries.\x5
          With --seeding or -s option to show only seeding log entries.\x5
          With --more=<More Token> or -m option to show older entries(newer entries if --head option used)\x5
          
          LONGDESC
      option :head, :aliases => :H
      option :parsing, :aliases => :p
      option :seeding, :aliases => :s
      option :more, :aliases => :m
      def log(job_id)
        client = Client::JobLog.new(options)

        query = {}
        query["order"] = options.delete(:head) if options[:head]
        query["job_type"] = options.delete(:parsing) if options[:parsing]
        query["job_type"] = options.delete(:seeding) if options[:seeding]
        query["page_token"] = options.delete(:more) if options[:more]
        
        result = client.all_job_log(job_id, {query: query})
        
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

      desc "stats <job_id>", "Get the current stat for a job"
      long_desc <<-LONGDESC
        Get current stat for a job\n

        <job_id>: The job ID.\x5
      LONGDESC
      def stats(job_id)
        client = Client::JobStat.new(options)
        puts "#{client.current(job_id)}"
      end

      desc "output SUBCOMMAND ...ARGS", "view job outputs"
      subcommand "output", JobOutput

    end
  end

end
