module AnswersEngine
  module Client
    class Job < AnswersEngine::Client::Base
      def all(opts={})
        params = @options.merge(opts)
        self.class.get("/jobs", params)
      end

      def find(job_id)
        self.class.get("/jobs/#{job_id}", @options)
      end

      def update(job_id, opts={})
        body = {}
        body[:status] = opts[:status] if opts[:status]
        body[:standard_worker_count] = opts[:workers] if opts[:workers]
        body[:browser_worker_count] = opts[:browsers] if opts[:browsers]
        params = @options.merge({body: body.to_json})

        self.class.put("/jobs/#{job_id}", params)
      end

      def cancel(job_id, opts={})
        opts[:status] = 'cancelled'
        update(job_id, opts)
      end

      def resume(job_id, opts={})
        opts[:status] = 'active'
        update(job_id, opts)
      end

      def pause(job_id, opts={})
        opts[:status] = 'paused'
        update(job_id, opts)
      end

      def seeding_update(job_id, opts={})
        body = {}
        body[:outputs] = opts.fetch(:outputs) {[]}
        body[:pages] = opts.fetch(:pages) {[]}
        body[:seeding_status] = opts.fetch(:seeding_status){ nil }
        body[:log_error] = opts[:log_error] if opts[:log_error]

        params = @options.merge({body: body.to_json})

        self.class.put("/jobs/#{job_id}/seeding_update", params)
      end

      def finisher_update(job_id, opts={})
        body = {}
        body[:outputs] = opts.fetch(:outputs) {[]}
        body[:finisher_status] = opts.fetch(:finisher_status){ nil }
        body[:log_error] = opts[:log_error] if opts[:log_error]

        params = @options.merge({body: body.to_json})

        self.class.put("/jobs/#{job_id}/finisher_update", params)
      end

    end

  end
end
