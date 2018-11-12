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

      desc "add <job_id> <url>", "Enqueues a page to the job"
      long_desc <<-LONGDESC
          Enqueues a page to a job\x5

          With --method or -m option to set method. Default: GET \x5
          With --page-type or -t option to set page_type \x5
          With --body or -b option to set body \x5
          With --headers or -H option to set headers. Must be in json format. i.e: {"Foo":"bar"} \x5
          With --force-fetch or -f option to set forcefetch to true or false \x5
          With --freshness or -s option to set freshness \x5
          With --ua-type or -u option to set user agent type: mobile or desktop \x5
          With --no-redirect or -n option to set noredirect to true or false\x5
          With --vars or -v option to set page vars. Must be in json format. i.e: {"Foo":"bar"} \x5
          
          LONGDESC
      option :method, :aliases => :m, type: :string
      option :headers, :aliases => :H, type: :string
      option :vars, :aliases => :v, type: :string
      option :page_type, :aliases => :t
      option :body, :aliases => :b
      option :force_fetch, :aliases => :f, type: :boolean
      option :freshness, :aliases => :s
      option :ua_type, :aliases => :u
      option :no_redirect, :aliases => :n, type: :boolean
      def add(job_id, url)
        begin
          options[:headers] = JSON.parse(options[:headers]) if options[:headers]
          options[:vars] = JSON.parse(options[:vars]) if options[:vars]
          method = options[:method]
          client = Client::JobPage.new(options)
          puts "#{client.enqueue(job_id, method, url, options)}"
        rescue JSON::ParserError
          if options[:headers]
            puts "Error: #{options[:headers]} on headers is not a valid JSON"
          end
          if options[:vars]
            puts "Error: #{options[:vars]} on vars is not a valid JSON"
          end
        end
      end


      desc "update <job_id> <gid>", "Update a page in a job"
      long_desc <<-LONGDESC
          Updates a page in a job. Only page_type is updateable
          With --page-type or -t option to set the page type\x5
          With --vars or -v option to set page vars. Must be in json format. i.e: {"Foo":"bar"} \x5
          
          LONGDESC
      option :page_type, :aliases => :t
      option :vars, :aliases => :v, type: :string
      def update(job_id, gid)
        begin
          options[:vars] = JSON.parse(options[:vars]) if options[:vars]
          client = Client::JobPage.new(options)
          puts "#{client.update(job_id, gid, options)}"
        rescue JSON::ParserError
          if options[:vars]
            puts "Error: #{options[:vars]} on vars is not a valid JSON"
          end
        end
      end

      desc "show <job_id> <gid>", "Show a page in job"
      def show(job_id, gid)
        client = Client::JobPage.new(options)
        puts "#{client.find(job_id, gid)}"
      end

      desc "log <job_id> <gid>", "List log entries related to a job page"
      long_desc <<-LONGDESC
          Shows log related to a page in the job. Defaults to showing the most recent entries\x5
          With --head or -H option to show the oldest log entries.\x5
          With --parsing or -p option to show only parsing log entries.\x5
          With --more=<More Token> or -m option to show older entries(newer entries if --head option used)\x5
          
          LONGDESC
      option :head, :aliases => :H
      option :parsing, :aliases => :p
      option :more, :aliases => :m
      def log(job_id, gid)
        client = Client::JobLog.new(options)

        query = {}
        query["order"] = options.delete(:head) if options[:head]
        query["job_type"] = options.delete(:parsing) if options[:parsing]
        query["page_token"] = options.delete(:more) if options[:more]
        
        result = client.all_job_page_log(job_id, gid, {query: query})
        
        unless result["entries"].nil?

          more_token = result["more_token"]

          result["entries"].each do |entry|
            puts "#{entry["timestamp"]} #{entry["severity"]}: #{entry["payload"]}" if entry.is_a?(Hash)
          end

          unless more_token == ""
            puts "to see more entries, add: \"--more #{more_token}\""
          end
        end
      end

    end
  end

end
