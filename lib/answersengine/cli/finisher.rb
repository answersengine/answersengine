module AnswersEngine
  class CLI < Thor
    class Finisher < Thor
      desc "try <scraper_name> <finisher_file>", "Tries a finisher file"
      long_desc <<-LONGDESC
            Takes a finisher script and tries to execute it without saving anything.\x5
            <seeder_file>: Finisher script file will be executed.\x5
          LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      def try_finisher(scraper_name, finisher_file)
        if options[:job]
          job_id = options[:job]
        else
          job = Client::ScraperJob.new(options).find(scraper_name)
          job_id = job['id']
        end

        puts AnswersEngine::Scraper::Finisher.exec_finisher(finisher_file, job_id, false)
      end

      desc "exec <scraper_name> <finisher_file>", "Executes a finisher script onto a scraper's current job."
      long_desc <<-LONGDESC
            Takes a finisher script and execute it against a job and save outputs into the scraper's current job\x5
            <finisher_file>: Finisher script file that will be executed on the scraper's current job.\x5
          LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      def exec_parse(scraper_name, finisher_file)
        if options[:job]
          job_id = options[:job]
        else
          job = Client::ScraperJob.new(options).find(scraper_name)
          job_id = job['id']
        end

        puts AnswersEngine::Scraper::Finisher.exec_finisher(finisher_file, job_id, true)
      end
    end
  end

end
