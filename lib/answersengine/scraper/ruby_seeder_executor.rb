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
          :outputs,
          :pages,
          :save_pages,
          :save_outputs,
          :find_output,
          :find_outputs
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
        update_seeding_starting_status

        proc = Proc.new do
          outputs = []
          pages = []

          begin
            context = isolated_binding({
              outputs: outputs,
              pages: pages
            })
            eval_with_context filename, context
          rescue SyntaxError => e
            handle_error(e) if save
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end

          puts "=========== Seeding Executed ==========="
          save_pages_and_outputs(pages, outputs, :seeding)
          update_seeding_done_status
        end
        proc.call
      end

      def save_type
        :seeding
      end

      def update_to_server(opts = {})
        seeding_update(
          job_id: opts[:job_id],
          pages: opts[:pages],
          outputs: opts[:outputs],
          seeding_status: opts[:status])
      end

      def update_seeding_starting_status
        return unless save

        response = seeding_update(
          job_id: job_id,
          seeding_status: :starting)

        if response.code == 200
          puts "Seeding Status Updated."
        else
          puts "Error: Unable to save Seeding Status to server: #{response.body}"
          raise "Unable to save Seeding Status to server: #{response.body}"
        end
      end

      def update_seeding_done_status
        return unless save

        response = seeding_update(
          job_id: job_id,
          seeding_status: :done)

        if response.code == 200
          puts "Seeding Done."
        else
          puts "Error: Unable to save Seeding Done Status to server: #{response.body}"
          raise "Unable to save Seeding Done Status to server: #{response.body}"
        end
      end

      def handle_error(e)
        error = ["Seeding #{e.class}: #{e.to_s} (Job:#{job_id}",clean_backtrace(e.backtrace)].join("\n")

        seeding_update(
          job_id: job_id,
          seeding_status: :failed,
          log_error: error)
      end

    end
  end
end
