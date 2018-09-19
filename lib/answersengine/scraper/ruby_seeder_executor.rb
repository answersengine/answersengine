module AnswersEngine
  module Scraper
    class RubySeederExecutor < Executor

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
      end

      def try_seeder
        try_seeder_script
      end

      def try_seeder_script
        proc = Proc.new do
          
          pages = []
          
          
          eval(File.read(filename), binding, filename)

          puts "=========== Seeding Done Successfully ==========="

          unless pages.empty?
            puts "----------- New Pages to Enqueue: -----------"
            puts JSON.pretty_generate(pages)
          end
        end
        proc.call
      end

    end
  end
end