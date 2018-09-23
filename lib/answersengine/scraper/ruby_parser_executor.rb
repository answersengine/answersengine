module AnswersEngine
  module Scraper
    class RubyParserExecutor < Executor

      def initialize(options={})
        @filename = options.fetch(:filename) { raise "Filename is required"}
        @gid = options.fetch(:gid) { raise "GID is required"}
        @job_id = options.fetch(:job_id)
      end

      def exec_parser(save=false)
        if save
          puts "Executing parser script"
        else
          puts "Trying parser script"
        end
        
        eval_parser_script(save)
      end

      def eval_parser_script(save=false)
        proc = Proc.new do
          page = init_page
          outputs = []
          pages = []
          content = get_content(gid)

          begin

            eval(File.read(filename), binding, filename)
          rescue SyntaxError => e
            handle_error(e) if save 
            raise e
          rescue => e
            handle_error(e) if save
            raise e
          end

          puts "=========== Parsing Executed ==========="

          if save
            # puts "output to save: #{{job_id: job_id, gid: gid,outputs: outputs, pages: pages}} "
            response = parsing_update(
              job_id: job_id, 
              gid: gid,
              outputs: outputs, 
              pages: pages) 

            if response.code == 200
              puts "Job Page Status Updated."
            else
              puts "Error: Unable to save to server: #{response.body}"
            end
          end

          unless outputs.empty?
            puts "----------- Outputs: -----------"
            puts JSON.pretty_generate(outputs)
          end

          unless pages.empty?
            puts "----------- New Pages to Enqueue: -----------"
            puts JSON.pretty_generate(pages)
            
          end
        end
        proc.call
      end

      def handle_error(e)
        error = ["Parsing #{e.class}: #{e.to_s} (Job:#{job_id} GID:#{gid})",e.backtrace].join("\n")
        
        parsing_update(
          job_id: job_id, 
          gid: gid, 
          parsing_failed: true, 
          log_error: error)
      end
    end
  end
end