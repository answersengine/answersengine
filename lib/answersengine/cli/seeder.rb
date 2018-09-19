module AnswersEngine
  class CLI < Thor
    class Seeder < Thor
      desc "try <seeder_file>", "Tries a seeder file"
      long_desc <<-LONGDESC
            Takes a seeder script and tries to execute it\n
            
            
            <seeder_file>: Which parser script file will be executed on the page.\n
            
            
            
            Example Usage: \x5
            answersengine seeder try seeder.rb\n
          LONGDESC
      def try_seed(seeder_file)
        puts AnswersEngine::Scraper::Seeder.try_seeder(seeder_file)
      end
    end
  end

end
