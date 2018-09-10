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

      desc "add <job_id> <method> <url>", "Enqueues a page to the job"
      long_desc <<-LONGDESC
          Enqueues a page to a job\x5

          With --page-type or -t option to set page_type \x5
          With --body or -b option to set body \x5
          With --headers or -H option to set headers. Must be in json format. i.e: {"Foo":"bar"} \x5
          With --force-fetch or -d option to set forcefetch to true or false \x5
          With --freshness or -s option to set freshness \x5
          With --ua-type or -u option to set user agent type: mobile or desktop \x5
          With --no-redirect or -n option to set noredirect to true or false\x5
          
          
          With --force-fetch or -f option to set true or false, defaults to false .
          LONGDESC
      option :headers, :aliases => :H, type: :string
      option :page_type, :aliases => :t
      option :body, :aliases => :b
      option :force_fetch, :aliases => :f, type: :boolean
      option :freshness, :aliases => :s
      option :ua_type, :aliases => :u
      option :no_redirect, :aliases => :n, type: :boolean
      def add(job_id, method, url)
        begin
          options[:headers] = JSON.parse(options[:headers]) if options[:headers]
          
          client = Client::JobPage.new(options)
          puts "#{client.enqueue(job_id, method, url, options)}"
        rescue JSON::ParserError
          puts "Error: #{options[:headers]} is not a valid JSON"
        end
      end


      desc "update <job_id> <gid>", "Update a page in a job"
      long_desc <<-LONGDESC
          Updates a page in a job. Only page_type is updateable
          With --page-type or -t option to set the page type.
          
          LONGDESC
      option :page_type, :aliases => :t
      def update(job_id, gid)
        client = Client::JobPage.new(options)
        puts "#{client.update(job_id, gid, options)}"
      end

      desc "show <job_id> <gid>", "Show a page in job"
      def show(job_id, gid)
        client = Client::JobPage.new(options)
        puts "#{client.find(job_id, gid)}"
      end

    end
  end

end
