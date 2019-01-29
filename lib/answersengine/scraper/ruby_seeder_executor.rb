module AnswersEngine
  module Scraper
    class RubySeederExecutor < Executor
      attr_accessor :save

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @job_id = options[:job_id]

      end

      def self.exposed_methods
        [
          :save_pages
        ].freeze
      end

      def exec_seeder(save=false)
        @save = save
        if save
          puts "Executing seeder script"
        else
          puts "Trying seeder script"
        end

        eval_seeder_script(save)
      end

      def eval_seeder_script(save=false)
        proc = Proc.new do
          pages = []

          begin
            context = isolated_binding({
              pages: pages
            })
            eval(File.read(filename), context, filename)

            if save
              save_pages(pages, true)
            end

            puts "=========== Seeding Script Executed ==========="

            unless pages.empty?
              puts "----------- New Pages to Enqueue: -----------"
              puts JSON.pretty_generate(pages)

            end


          rescue SyntaxError => e
            handle_error(e) if save
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end
        end
        proc.call
      end

      def save_pages(pages=[], seeding_done = false)
        if save
          total_pages = pages.count
          pages_per_slice = 100
          until pages.empty?
            pages_slice = pages.shift(pages_per_slice)
            log_msg = "Seeding #{pages_slice.count} out of #{total_pages} Pages"
            puts "log_info: #{log_msg}"

            response = seeding_update(
              job_id: job_id,
              pages: pages_slice,
              seeding_done: seeding_done)

            if response.code == 200
              puts "Job Seed Updated."
              puts "Seeding done." if seeding_done
            else
              puts "Error: Unable to save to server: #{response.body}"
              raise "Unable to save to server: #{response.body}"
            end
          end
        end
      end

      def handle_error(e)
        error = ["Seeding #{e.class}: #{e.to_s} (Job:#{job_id}",clean_backtrace(e.backtrace)].join("\n")

        seeding_update(
          job_id: job_id,
          seeding_failed: true,
          log_error: error)
      end

    end
  end
end
