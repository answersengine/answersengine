module AnswersEngine
  module Scraper
    class RubyFinisherExecutor < Executor
      attr_accessor :save

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @job_id = options[:job_id]
      end

      def self.exposed_methods
        [
          :outputs,
          :save_outputs,
          :find_output,
          :find_outputs
        ].freeze
      end

      def exec_finisher(save=false)
        @save = save
        if save
          puts "Executing finisher script"
        else
          puts "Trying finisher script"
        end

        eval_finisher_script(save)
      end

      def eval_finisher_script(save=false)
        update_finisher_starting_status

        proc = Proc.new do
          outputs = []

          begin
            context = isolated_binding({
              outputs: outputs,
              job_id: job_id
            })
            eval_with_context filename, context
          rescue SyntaxError => e
            handle_error(e) if save
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end

          puts "=========== Finisher Executed ==========="
          save_outputs(outputs)
          update_finisher_done_status
        end
        proc.call
      end

      def save_type
        :finisher
      end

      def update_to_server(opts = {})
        finisher_update(
          job_id: opts[:job_id],
          outputs: opts[:outputs],
          finisher_status: opts[:status])
      end

      def update_finisher_starting_status
        return unless save

        response = finisher_update(
          job_id: job_id,
          finisher_status: :starting)

        if response.code == 200
          puts "Finisher Status Updated."
        else
          puts "Error: Unable to save Finisher Status to server: #{response.body}"
          raise "Unable to save Finisher Status to server: #{response.body}"
        end
      end

      def update_finisher_done_status
        return unless save

        response = finisher_update(
          job_id: job_id,
          finisher_status: :done)

        if response.code == 200
          puts "Finisher Done."
        else
          puts "Error: Unable to save Finisher Done Status to server: #{response.body}"
          raise "Unable to save Finisher Done Status to server: #{response.body}"
        end
      end

      def handle_error(e)
        error = ["Finisher #{e.class}: #{e.to_s} (Job:#{job_id}",clean_backtrace(e.backtrace)].join("\n")

        finisher_update(
          job_id: job_id,
          finisher_status: :failed,
          log_error: error)
      end

    end
  end
end
