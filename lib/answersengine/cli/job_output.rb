module AnswersEngine
  class CLI < Thor
    class JobOutput < Thor

      package_name "job output"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "list <job_id>", "List all output records in a collection"
      option :page, :aliases => :p
      option :collection, :aliases => :c
      long_desc <<-LONGDESC
        List all output records in a collection\n

        <job_id>: The job ID.\x5

        With --collection or -c option to query against a collection.(defaults to 'default' collection)\x5
        With --page or -p option to get the next set of records by page.
      LONGDESC
      def list(job_id)
        collection = options.fetch(:collection) { 'default' }
        client = Client::JobOutput.new(options)
        puts "#{client.all(job_id, collection)}"
      end

      desc "show <job_id> <id>", "Show an output record in a collection"
      long_desc <<-LONGDESC
        Shows an output record in a collection\n

        <job_id>: The job ID.\x5
        <collection>: The name of the collection.\x5
        <id>: ID of the output record.\x5
        With --collection or -c option to query against a collection.(defaults to 'default' collection)\x5
      LONGDESC
      option :collection, :aliases => :c
      def show(job_id, id)
        collection = options.fetch(:collection) { 'default' }
        client = Client::JobOutput.new(options)
        puts "#{client.find(job_id, collection, id)}"
      end

      desc "collections <job_id>", "list job output's collections"
      long_desc <<-LONGDESC
        List all collections that are created in a job.
   
        With --page or -p option to get the next set of records by page.
      LONGDESC
      option :page, :aliases => :p
      def collections(job_id)
        client = Client::JobOutput.new(options)
        puts "#{client.collections(job_id)}"
      end

    end
  end

end
