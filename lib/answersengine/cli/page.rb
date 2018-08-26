module AnswersEngine
  class CLI < Thor
    class Page < Thor

      desc "list <job_id>", "List Pages on a job"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        List all pages in a job.
   
        With --page or -p option to get the next set of records by page.
      LONGDESC
      def list(job_id)
        client = Client::JobPage.new(options)
        puts "#{client.all(job_id)}"
      end

      desc "show <job_id> <gid>", "Show a page in job"
      def show(job_id, gid)
        client = Client::JobPage.new(options)
        puts "#{client.find(job_id, gid)}"
      end

    end
  end

end
