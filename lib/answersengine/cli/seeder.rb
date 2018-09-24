module AnswersEngine
  class CLI < Thor
    class Seeder < Thor
      desc "try <seeder_file>", "Tries a seeder file"
      long_desc <<-LONGDESC
            Takes a seeder script and tries to execute it without saving anything\n

            <seeder_file>: Which parser script file will be executed on the page.\x5

            Example Usage: \x5
            answersengine seeder try seeder.rb\n
          LONGDESC
      def try_seed(seeder_file)
        puts AnswersEngine::Scraper::Seeder.exec_seeder(seeder_file, nil, false)
      end

      desc "exec <job_id> <seeder_file>", "Executes a seeder script onto a Job"
      long_desc <<-LONGDESC
            Takes a seeder script and execute it against a job and enqueues the pages into the job\n
            
            <job_id>: Global ID of the page.\x5
            <seeder_file>: Which parser script file will be executed on the page.\x5
            
            Example Usage: \x5
            answersengine seeder exec 123 \n
          LONGDESC
      def exec_parse(job_id, seeder_file)
        puts AnswersEngine::Scraper::Seeder.exec_seeder(seeder_file, job_id, true)
      end
    end
  end

end
