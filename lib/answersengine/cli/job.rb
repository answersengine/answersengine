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
    end
  end

end
