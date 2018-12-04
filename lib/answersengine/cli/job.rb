module AnswersEngine
  class CLI < Thor
    class Job < Thor
      package_name "job"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end


      desc "list", "gets a list of jobs"
      option :page, :aliases => :p, type: :numeric, desc: 'Get the next set of records by page.'
      option :per_page, :aliases => :P, type: :numeric, desc: 'Number of records per page. Max 500 per page.'
      long_desc <<-LONGDESC
        List scrape jobs.
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

    end
  end

end
